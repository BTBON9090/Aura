import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:isar/isar.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import '../../data/models/album_model.dart'; // 🚀 补上了相册数据模型引用
import '../photos/photo_gallery_view.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({super.key});

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  Future<Map<String, dynamic>> _getAlbumMetadata(String? type) async {
    final db = IsarService.db;
    var query = db.imageModels.filter().deletedTimeIsNull();

    if (type == 'high_rated') {
      query = query.ratingGreaterThan(3);
    } else if (type == 'screenshots') {
      query = query.extensionEqualTo('png').or().filenameContains('screenshot', caseSensitive: false);
    } else if (type == 'videos') {
      query = query.extensionEqualTo('mp4').or().extensionEqualTo('mov');
    }

    final count = await query.count();
    String? coverPath;
    
    if (count > 0) {
      final latestPhoto = await query.sortByAddedTimeDesc().findFirst();
      coverPath = latestPhoto?.path;
    }

    return {'count': count, 'cover': coverPath};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: CustomScrollView(
        slivers:[
          _buildAppBar(),
          _buildSectionTitle('常用相册'),
          _buildSmartAlbums(context),
          _buildSectionTitle(
            '自定义相册', 
            trailing: IconButton(
              icon: const Icon(LucideIcons.plusCircle, color: Color(0xFFE70FAD), size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showCreateAlbumDialog(context),
            ),
          ),
          _buildCustomAlbums(context),
          _buildRecycleBinLink(context),
          const SliverToBoxAdapter(child: SizedBox(height: 120)), 
        ],
      ),
    );
  }

  Widget _buildSmartAlbums(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.3, 
        children:[
          _buildAlbumCard(context, '全部照片', LucideIcons.image, null, const Color(0xFFE70FAD)),
          _buildAlbumCard(context, '高分精选', LucideIcons.star, 'high_rated', const Color(0xFFFFD700)),
          _buildAlbumCard(context, '最近截图', LucideIcons.smartphone, 'screenshots', const Color(0xFF4CAF50)),
          _buildAlbumCard(context, '视频', LucideIcons.video, 'videos', const Color(0xFF2196F3)),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(BuildContext context, String title, IconData icon, String? type, Color iconColor) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAlbumMetadata(type),
      builder: (context, snapshot) {
        final int count = snapshot.data?['count'] ?? 0;
        final String? coverPath = snapshot.data?['cover'];

        return GestureDetector(
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(
              builder: (_) => PhotoGalleryView(title: title, filterType: type)
            ));
            setState(() {}); 
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children:[
                Container(
                  width: 68, 
                  height: double.infinity,
                  padding: const EdgeInsets.all(6), 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: coverPath != null
                        ? ExtendedImage.file(File(coverPath), fit: BoxFit.cover, cacheWidth: 200, enableLoadState: false)
                        : Container(color: const Color(0xFFF6F6F8), child: Icon(icon, color: Colors.grey.shade400, size: 24)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children:[
                            Icon(icon, color: iconColor, size: 14),
                            const SizedBox(width: 6),
                            Text('$count', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildRecycleBinLink(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAlbumMetadata('deleted_placeholder'),
      builder: (context, snapshot) {
        int deletedCount = 0;
        if (IsarService.db != null) {
           deletedCount = IsarService.db.imageModels.filter().deletedTimeIsNotNull().countSync();
        }

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoGalleryView(title: '回收站', filterType: 'deleted')));
                setState(() {}); 
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children:[
                    const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 22),
                    const SizedBox(width: 16),
                    const Text('回收站', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    const SizedBox(width: 8),
                    if (deletedCount > 0)
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text('$deletedCount', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold))),
                    const Spacer(),
                    const Text('90天后自动清理', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  
  // 🚀 恢复丝滑大标题与右侧图标组
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF6F6F8),
      surfaceTintColor: Colors.transparent,
      pinned: true,
      expandedHeight: 120.0, // 展开高度，实现上滑缩小动效
      flexibleSpace: const FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          '相册',
          style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), letterSpacing: 1.2),
        ),
      ),
      actions:[
        IconButton(
          icon: const Icon(LucideIcons.search, color: Color(0xFF1A1A1A)),
          onPressed: () {}, // 预留搜索接口
        ),
        IconButton(
          icon: const Icon(LucideIcons.moreHorizontal, color: Color(0xFF1A1A1A)),
          onPressed: () {}, // 预留更多设置接口
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {Widget? trailing}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAlbums(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: IsarService.getCustomAlbums(),
      builder: (context, snapshot) {
        final albums = snapshot.data ??[];

        if (albums.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('点击右上角 + 号新建相册', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75, 
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return _buildCustomAlbumCard(context, album);
            },
          ),
        );
      }
    );
  }

  Widget _buildCustomAlbumCard(BuildContext context, AlbumModel album) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoGalleryView(title: album.name, albumId: album.id)));
        setState(() {}); 
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
              child: FutureBuilder<String?>(
                future: IsarService.getAlbumCover(album.id),
                builder: (context, coverSnap) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: coverSnap.data != null
                        ? ExtendedImage.file(File(coverSnap.data!), fit: BoxFit.cover, cacheWidth: 300)
                        : Icon(LucideIcons.image, color: Colors.grey.shade300, size: 32), // 🚀 修正了这里的图标名称
                  );
                }
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(album.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
          FutureBuilder<int>(
            future: IsarService.getPhotoCountInAlbum(album.id),
            builder: (context, countSnap) {
              return Text('${countSnap.data ?? 0} 张照片', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold));
            }
          ),
        ],
      ),
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF6F6F8),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), 
        title: const Text('新建相册', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        content: TextField(
          controller: controller,
          autofocus: true,
          cursorColor: const Color(0xFFE70FAD),
          decoration: InputDecoration(
            hintText: '输入相册名称',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        actions:[
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE70FAD), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await IsarService.createAlbum(controller.text.trim());
                if (context.mounted) Navigator.pop(context);
                setState(() {}); 
              }
            },
            child: const Text('创建', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}