import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({super.key});

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  int _totalCount = 0;
  int _highRatedCount = 0;
  int _screenshotCount = 0; 
  String? _latestCoverPath;
  String? _latestHighRatedCoverPath;
  String? _latestScreenshotCoverPath;

  // 标签统计数据
  int _globalTagCount = 0;
  int _untaggedCount = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbumStats();
  }

  Future<void> _loadAlbumStats() async {
    final db = IsarService.db;
    if (db == null) return;

    final totalPhotos = await db.imageModels.where().sortByAddedTimeDesc().findAll();
    _totalCount = totalPhotos.length;
    if (totalPhotos.isNotEmpty) _latestCoverPath = totalPhotos.first.path;

    final highRated = await db.imageModels.filter().ratingGreaterThan(3).sortByAddedTimeDesc().findAll();
    _highRatedCount = highRated.length;
    if (highRated.isNotEmpty) _latestHighRatedCoverPath = highRated.first.path;

    final screenshots = await db.imageModels.filter().extensionEqualTo('png').sortByAddedTimeDesc().findAll();
    _screenshotCount = screenshots.length;
    if (screenshots.isNotEmpty) _latestScreenshotCoverPath = screenshots.first.path;

    // 加载标签统计
    final allTags = await IsarService.getAllUniqueTags();
    _globalTagCount = allTags.length;
    _untaggedCount = await IsarService.getUntaggedCount();

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE70FAD)))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers:[
                SliverAppBar(
                  backgroundColor: const Color(0xFFF6F6F8),
                  surfaceTintColor: Colors.transparent,
                  pinned: true,
                  expandedHeight: 120.0,
                  flexibleSpace: const FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                    title: Text('相册', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ),
                  actions:[
                    IconButton(icon: const Icon(LucideIcons.search, size: 28, color: Color(0xFF1A1A1A)), onPressed: () {}),
                    const SizedBox(width: 8),
                  ],
                ),

                // 1. 常用相册
                _buildSectionHeader(title: "常用相册", actionText: "更多", onActionTap: () {}),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75,
                    children:[
                      _AlbumCard(title: "全部照片", count: _totalCount, coverPath: _latestCoverPath, icon: LucideIcons.image),
                      _AlbumCard(title: "高分精选", count: _highRatedCount, coverPath: _latestHighRatedCoverPath, icon: LucideIcons.star),
                      _AlbumCard(title: "近期截图", count: _screenshotCount, coverPath: _latestScreenshotCoverPath, icon: LucideIcons.monitorSmartphone),
                    ],
                  ),
                ),

                // 🚀 2. Eagle 级标签管理器 (彻底重构)
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        // 主标签菜单
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))]),
                          child: Column(
                            children:[
                              _buildEagleMenuTile(icon: LucideIcons.bookmark, title: "全部标签", count: _globalTagCount, isTop: true),
                              const Divider(height: 1, indent: 44, color: Color(0xFFF0F0F0)),
                              _buildEagleMenuTile(icon: LucideIcons.folderSearch, title: "未分类照片", count: _untaggedCount),
                              const Divider(height: 1, indent: 44, color: Color(0xFFF0F0F0)),
                              _buildEagleMenuTile(icon: LucideIcons.star, title: "常用标签", isBottom: true),
                            ],
                          ),
                        ),
                        
                        // 标签群组头部
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4, top: 20, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              const Text("标签群组 (1)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                              InkWell(onTap: () => HapticFeedback.lightImpact(), child: const Icon(LucideIcons.plus, size: 18, color: Colors.grey)),
                            ],
                          ),
                        ),
                        
                        // 标签群组列表
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))]),
                          child: Column(
                            children:[
                              _buildEagleMenuTile(icon: LucideIcons.bookmarkMinus, title: "未命名群组", count: 0, isTop: true, isBottom: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. 自定义相册
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                _buildSectionHeader(title: "我的相册", actionText: "新建", onActionTap: () {}),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE70FAD).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(LucideIcons.folderPlus, color: Color(0xFFE70FAD), size: 24)),
                            const SizedBox(height: 8),
                            const Text("新建私密相册", style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. 底部功能区
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildUtilityTile(icon: LucideIcons.trash2, title: "最近删除", subtitle: "90天内可恢复", color: Colors.redAccent),
                      const SizedBox(height: 12),
                      _buildUtilityTile(icon: LucideIcons.settings, title: "高级设置", subtitle: "隐匿伪装与沙盒规则", color: Colors.blueGrey),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
    );
  }

  Widget _buildSectionHeader({required String title, required String actionText, required VoidCallback onActionTap}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 16, top: 16, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            if (actionText.isNotEmpty)
              TextButton(onPressed: () { HapticFeedback.lightImpact(); onActionTap(); }, child: Text(actionText, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)))
          ],
        ),
      ),
    );
  }

  // 🚀 Eagle 风格精致 List Tile
  Widget _buildEagleMenuTile({required IconData icon, required String title, int? count, bool isTop = false, bool isBottom = false}) {
    return InkWell(
      onTap: () => HapticFeedback.selectionClick(),
      borderRadius: BorderRadius.vertical(top: Radius.circular(isTop ? 16 : 0), bottom: Radius.circular(isBottom ? 16 : 0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children:[
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)))),
            if (count != null)
              Text(count.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'Courier')),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityTile({required IconData icon, required String title, required String subtitle, required Color color}) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Row(
          children:[
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ])),
            const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AlbumCard extends StatefulWidget {
  final String title; final int count; final String? coverPath; final IconData icon;
  const _AlbumCard({required this.title, required this.count, this.coverPath, required this.icon});
  @override State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard> {
  bool _isPressed = false;
  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true), onTapUp: (_) => setState(() => _isPressed = false), onTapCancel: () => setState(() => _isPressed = false),
      onTap: () { HapticFeedback.lightImpact(); },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Expanded(child: Container(width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))]), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: widget.coverPath != null ? Image.file(File(widget.coverPath!), fit: BoxFit.cover, cacheWidth: 300) : Center(child: Icon(widget.icon, size: 32, color: Colors.grey.shade300))))),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(widget.count > 0 ? "${widget.count} 张" : "空", style: const TextStyle(fontSize: 12, color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}