import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:extended_image/extended_image.dart';
import '../../data/isar_service.dart';
import '../../data/models/album_model.dart';
import '../../data/models/image_model.dart';
import '../../core/globals.dart'; // 全局状态
import '../photos/photo_gallery_view.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({super.key});

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  bool _isLoading = true;

  // 状态缓存：标签
  int _globalTagCount = 0;
  int _untaggedCount = 0;

  // 状态缓存：常用相册 (存储 count 和 coverPath)
  Map<String, Map<String, dynamic>> _smartAlbumsData = {};

  // 状态缓存：自定义相册
  List<AlbumModel> _customAlbums = [];
  Map<int, int> _customAlbumCounts = {};
  Map<int, String?> _customAlbumCovers = {};

  @override
  void initState() {
    super.initState();
    _refreshStats();
    globalAlbumRefreshNotifier.addListener(_onAlbumRefresh);
  }

  @override
  void dispose() {
    globalAlbumRefreshNotifier.removeListener(_onAlbumRefresh);
    super.dispose();
  }

  void _onAlbumRefresh() {
    if (globalAlbumRefreshNotifier.value) {
      _refreshStats();
      globalAlbumRefreshNotifier.value = false;
    }
  }

  // 🚀 核心修复：集中预加载所有数据，彻底消灭 FutureBuilder 导致的滚动卡顿和 Sliver 崩溃
  Future<void> _refreshStats() async {
    // 1. 加载标签
    final tags = await IsarService.getAllUniqueTags();
    final untagged = await IsarService.getUntaggedCount();

    // 2. 加载常用相册
    final allData = await _getAlbumMetadata(null);
    final highRatedData = await _getAlbumMetadata('high_rated');
    final screenshotData = await _getAlbumMetadata('screenshots');
    final videoData = await _getAlbumMetadata('videos');

    // 3. 加载自定义相册
    final customAlbums = await IsarService.getCustomAlbums();
    Map<int, int> counts = {};
    Map<int, String?> covers = {};
    for (var album in customAlbums) {
      counts[album.id] = await IsarService.getPhotoCountInAlbum(album.id);
      covers[album.id] = await IsarService.getAlbumCover(album.id);
    }

    if (mounted) {
      setState(() {
        _globalTagCount = tags.length;
        _untaggedCount = untagged;

        _smartAlbumsData = {
          'all': allData,
          'high_rated': highRatedData,
          'screenshots': screenshotData,
          'videos': videoData,
        };

        _customAlbums = customAlbums;
        _customAlbumCounts = counts;
        _customAlbumCovers = covers;

        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getAlbumMetadata(String? type) async {
    final db = IsarService.db;

    List<dynamic> photos;
    if (type == 'high_rated') {
      photos = await db.imageModels
          .filter()
          .deletedTimeIsNull()
          .ratingGreaterThan(3)
          .sortByAddedTimeDesc()
          .findAll();
    } else if (type == 'screenshots') {
      final allPhotos = await db.imageModels
          .filter()
          .deletedTimeIsNull()
          .sortByAddedTimeDesc()
          .findAll();
      final screenshotKeywords = [
        'screenshot',
        'screen_shot',
        'screen-shot',
        '截屏',
        '截图',
        '1774104680468074',
      ];
      photos = allPhotos.where((p) {
        final pathLower = p.path.toLowerCase();
        final nameLower = p.filename.toLowerCase();
        return screenshotKeywords.any(
          (keyword) =>
              pathLower.contains(keyword.toLowerCase()) ||
              nameLower.contains(keyword.toLowerCase()),
        );
      }).toList();
    } else if (type == 'videos') {
      const videoExtensions = [
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
        '3gp',
        'flv',
        'wmv',
        'm4v',
        'mpeg',
        'mpg',
      ];
      final allPhotos = await db.imageModels
          .filter()
          .deletedTimeIsNull()
          .sortByAddedTimeDesc()
          .findAll();
      photos = allPhotos
          .where((p) => videoExtensions.contains(p.extension.toLowerCase()))
          .toList();
    } else {
      photos = await db.imageModels
          .filter()
          .deletedTimeIsNull()
          .sortByAddedTimeDesc()
          .findAll();
    }

    final count = photos.length;
    final coverPath = count > 0
        ? (photos.first as dynamic).path as String?
        : null;
    return {'count': count, 'cover': coverPath};
  }

  // ================= 构建区 =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE70FAD)),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                _buildAppBar(),

                _buildSectionTitle('常用相册'),
                _buildSmartAlbums(context),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildSectionTitle('资产标签'),
                _buildTagSection(context),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildSectionTitle('自定义相册'),
                _buildCustomAlbums(context),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                _buildBottomUtilities(context),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ), // 避让悬浮导航栏
              ],
            ),
    );
  }

  // ================= 组件区 =================
  // 构建AppBar
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF6F6F8),
      surfaceTintColor: Colors.transparent,
      pinned: true,
      expandedHeight: 120.0,
      flexibleSpace: const FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          '相册',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1A1A),
            letterSpacing: 1.2,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.search, color: Color(0xFF1A1A1A)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            LucideIcons.moreHorizontal,
            color: Color(0xFF1A1A1A),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // 构建标题
  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 16, top: 16, bottom: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  // 构建常用相册部分
  Widget _buildSmartAlbums(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.3,
        children: [
          _buildAlbumCard(
            context,
            '全部照片',
            LucideIcons.image,
            null,
            const Color(0xFFE70FAD),
            _smartAlbumsData['all'],
          ),
          _buildAlbumCard(
            context,
            '高分精选',
            LucideIcons.star,
            'high_rated',
            const Color(0xFFFFD700),
            _smartAlbumsData['high_rated'],
          ),
          _buildAlbumCard(
            context,
            '最近截图',
            LucideIcons.smartphone,
            'screenshots',
            const Color(0xFF4CAF50),
            _smartAlbumsData['screenshots'],
          ),
          _buildAlbumCard(
            context,
            '视频',
            LucideIcons.video,
            'videos',
            const Color(0xFF2196F3),
            _smartAlbumsData['videos'],
          ),
        ],
      ),
    );
  }

  // 构建相册卡片
  Widget _buildAlbumCard(
    BuildContext context,
    String title,
    IconData icon,
    String? type,
    Color iconColor,
    Map<String, dynamic>? data,
  ) {
    final int count = data?['count'] ?? 0;
    final String? coverPath = data?['cover'];

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PhotoGalleryView(title: title, filterType: type),
          ),
        );
        _refreshStats();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 88,
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: coverPath != null
                    ? ExtendedImage.file(
                        File(coverPath),
                        fit: BoxFit.cover,
                        cacheWidth: 200,
                        enableLoadState: false,
                      )
                    : Container(
                        color: const Color(0xFFF6F6F8),
                        child: Icon(
                          icon,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建标签管理部分
  Widget _buildTagSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMenuTile(
                LucideIcons.bookmark,
                "标签管理",
                _globalTagCount,
                isTop: true,
                onTap: () {
                  // TODO: 跳转至“展示所有标签”的瀑布流页
                },
              ),
              const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0)),
              _buildMenuTile(
                LucideIcons.tag,
                "未分类标签",
                0,
                onTap: () {
                  // TODO: 跳转至没有进行分组的标签列表
                },
              ),
              const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0)),
              _buildMenuTile(
                LucideIcons.star,
                "常用标签",
                0,
                onTap: () {
                  // TODO: 跳转至 Marked as Common 的标签
                },
              ),
              const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0)),
              _buildMenuTile(
                LucideIcons.layers,
                "标签分组",
                0,
                isBottom: true,
                onTap: () {
                  // TODO: 🚀 这里进入你要求的“高自由度侧边栏管理界面”
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建标签管理部分的菜单项
  Widget _buildMenuTile(
    IconData icon,
    String title,
    int count, {
    bool isTop = false,
    bool isBottom = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () async {
        HapticFeedback.selectionClick();
        if (onTap != null) {
          onTap();
        } else {
          _refreshStats();
        }
      },
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isTop ? 20 : 0),
        bottom: Radius.circular(isBottom ? 20 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey.shade600),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 构建自定义相册部分
  Widget _buildCustomAlbums(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _customAlbums.length + 1,
        itemBuilder: (context, index) {
          if (index == _customAlbums.length)
            return _buildCreateAlbumCard(context);
          return _buildCustomAlbumCard(context, _customAlbums[index]);
        },
      ),
    );
  }

  // 构建自定义相册卡片
  Widget _buildCustomAlbumCard(BuildContext context, AlbumModel album) {
    final int count = _customAlbumCounts[album.id] ?? 0;
    final String? coverPath = _customAlbumCovers[album.id];

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PhotoGalleryView(title: album.name, albumId: album.id),
          ),
        );
        _refreshStats();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: coverPath != null
                    ? ExtendedImage.file(
                        File(coverPath),
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                      )
                    : Icon(
                        LucideIcons.image,
                        color: Colors.grey.shade300,
                        size: 32,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              album.name,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              count > 0 ? '$count 张' : '空',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // 构建新建相册卡片
  Widget _buildCreateAlbumCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showCreateAlbumDialog(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE70FAD).withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.folderPlus,
                    color: Color(0xFFE70FAD),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '新建相册',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '点击创建',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // 显示新建相册对话框
  void _showCreateAlbumDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF6F6F8),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text(
          '新建相册',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          cursorColor: const Color(0xFFE70FAD),
          decoration: InputDecoration(
            hintText: '输入相册名称',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE70FAD),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await IsarService.createAlbum(controller.text.trim());
                if (context.mounted) Navigator.pop(context);
                _refreshStats();
              }
            },
            child: const Text(
              '创建',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 构建底部工具栏
  Widget _buildBottomUtilities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildUtilityTile(
            context,
            LucideIcons.trash2,
            "最近删除",
            "90天内可恢复",
            Colors.redAccent,
            'deleted',
          ),
          const SizedBox(height: 12),
          _buildUtilityTile(
            context,
            LucideIcons.settings,
            "高级设置",
            "隐匿伪装与沙盒规则",
            Colors.blueGrey,
            null,
          ),
        ]),
      ),
    );
  }

  // 构建底部工具栏的工具项
  Widget _buildUtilityTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    String? filterType,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        if (filterType == 'deleted') {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const PhotoGalleryView(title: '最近删除', filterType: 'deleted'),
            ),
          );
          _refreshStats();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
