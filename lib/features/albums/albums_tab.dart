import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({super.key});

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  // 智能相册的统计数据
  int _totalCount = 0;
  int _highRatedCount = 0;
  int _screenshotCount = 0; // 假定 png 为截图
  String? _latestCoverPath;
  String? _latestHighRatedCoverPath;
  String? _latestScreenshotCoverPath;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbumStats();
  }

  // 🚀 核心：利用 Isar 极速引擎，在进入页面瞬间计算好所有智能相册的封面和数量
  Future<void> _loadAlbumStats() async {
    final db = IsarService.db;
    if (db == null) return;

    // 1. 全部照片
    final totalPhotos = await db.imageModels.where().sortByAddedTimeDesc().findAll();
    _totalCount = totalPhotos.length;
    if (totalPhotos.isNotEmpty) _latestCoverPath = totalPhotos.first.path;

    // 2. 高分精选 (评分 >= 4)
    final highRated = await db.imageModels.filter().ratingGreaterThan(3).sortByAddedTimeDesc().findAll();
    _highRatedCount = highRated.length;
    if (highRated.isNotEmpty) _latestHighRatedCoverPath = highRated.first.path;

    // 3. 截屏/录屏 (简单根据扩展名模拟 png)
    final screenshots = await db.imageModels.filter().extensionEqualTo('png').sortByAddedTimeDesc().findAll();
    _screenshotCount = screenshots.length;
    if (screenshots.isNotEmpty) _latestScreenshotCoverPath = screenshots.first.path;

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8), // 温润灰白底色
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE70FAD)))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers:[
                // 1. 现代化大排版 AppBar
                SliverAppBar(
                  backgroundColor: const Color(0xFFF6F6F8),
                  surfaceTintColor: Colors.transparent,
                  pinned: true,
                  expandedHeight: 120.0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: const Text(
                      '相册',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  actions:[
                    IconButton(
                      icon: const Icon(LucideIcons.search, size: 28, color: Color(0xFF1A1A1A)),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // TODO: 搜索页
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // 2. 常用相册 (智能分类)
                _buildSectionHeader(title: "常用相册", onActionTap: () {}),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75, // 控制封面卡片的宽高比 (略微修长)
                    children:[
                      _AlbumCard(
                        title: "全部照片",
                        count: _totalCount,
                        coverPath: _latestCoverPath,
                        icon: LucideIcons.image,
                      ),
                      _AlbumCard(
                        title: "高分精选",
                        count: _highRatedCount,
                        coverPath: _latestHighRatedCoverPath,
                        icon: LucideIcons.star,
                      ),
                      _AlbumCard(
                        title: "近期截图",
                        count: _screenshotCount,
                        coverPath: _latestScreenshotCoverPath,
                        icon: LucideIcons.monitorSmartphone,
                      ),
                    ],
                  ),
                ),

                // 3. 自定义相册
                _buildSectionHeader(title: "我的相册", actionText: "新建", onActionTap: () {}),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFE70FAD).withOpacity(0.1), shape: BoxShape.circle),
                              child: const Icon(LucideIcons.folderPlus, color: Color(0xFFE70FAD), size: 28),
                            ),
                            const SizedBox(height: 12),
                            const Text("新建私密相册", style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. 底部功能区 (回收站 / 设置等)
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildUtilityTile(icon: LucideIcons.trash2, title: "最近删除", subtitle: "90天内可恢复", color: Colors.redAccent),
                      const SizedBox(height: 12),
                      _buildUtilityTile(icon: LucideIcons.cpu, title: "释放空间", subtitle: "清理相似图片与缓存", color: const Color(0xFFE70FAD)),
                      const SizedBox(height: 12),
                      _buildUtilityTile(icon: LucideIcons.settings, title: "高级设置", subtitle: "隐匿伪装与沙盒规则", color: Colors.blueGrey),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)), // 底部防遮挡留白
              ],
            ),
    );
  }

  // 标题区构造器
  Widget _buildSectionHeader({required String title, String actionText = "更多", required VoidCallback onActionTap}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 16, top: 16, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onActionTap();
              },
              child: Text(actionText, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }

  // 底部功能列表块
  Widget _buildUtilityTile({required IconData icon, required String title, required String subtitle, required Color color}) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children:[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
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

// 🚀 核心组件：带有阻尼微动效的大圆角相册卡片
class _AlbumCard extends StatefulWidget {
  final String title;
  final int count;
  final String? coverPath;
  final IconData icon;

  const _AlbumCard({required this.title, required this.count, this.coverPath, required this.icon});

  @override
  State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        // TODO: 点击进入相册详情页 (传入对应的 Isar Filter 规则)
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 相册封面
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.coverPath != null
                      ? Image.file(
                          File(widget.coverPath!),
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                        )
                      : Center(child: Icon(widget.icon, size: 32, color: Colors.grey.shade300)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 相册信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                widget.count > 0 ? "${widget.count} 张" : "空",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}