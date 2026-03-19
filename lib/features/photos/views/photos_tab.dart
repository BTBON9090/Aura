import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../data/isar_service.dart';
import '../../../data/models/image_model.dart';

class PhotosTab extends StatefulWidget {
  const PhotosTab({Key? key}) : super(key: key);

  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  // 核心状态：当前瀑布流/宫格的列数 (默认 3 列)
  int _crossAxisCount = 3;
  double _baseScale = 1.0;
  int _baseCrossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8), // 极简现代暖灰白背景
      // 使用 GestureDetector 拦截双指缩放手势，实现无极缩放布局
      body: GestureDetector(
        onScaleStart: (details) {
          _baseScale = 1.0;
          _baseCrossAxisCount = _crossAxisCount;
        },
        onScaleUpdate: (details) {
          setState(() {
            // 根据缩放比例动态计算列数（阻尼感调整）
            // scale > 1 (放大手势) -> 列数减少，图片变大
            // scale < 1 (缩小手势) -> 列数增加，图片变小
            double newCount = _baseCrossAxisCount / details.scale;
            // 限制列数范围：最少 2 列，最多 8 列
            _crossAxisCount = newCount.clamp(2.0, 8.0).round();
          });
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), // 强阻尼弹性效果
          slivers:[
            // 现代化大排版 AppBar
            SliverAppBar(
              backgroundColor: const Color(0xFFF6F6F8),
              surfaceTintColor: Colors.transparent, // 消除 Material 3 默认的混色
              pinned: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: const Text(
                  'Aura 照片',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24, // 强调排版张力
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            
            // 响应式数据流加载
            StreamBuilder<List<ImageModel>>(
              // Isar 的超强特性：监听数据变化，按添加时间倒序
              stream: IsarService.db!.imageModels.where().sortByAddedTimeDesc().watch(fireImmediately: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Color(0xFFE70FAD))));
                }

                final images = snapshot.data!;
                if (images.isEmpty) {
                  return _buildEmptyState();
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  // 使用 AnimatedSwitcher 配合跨轴数量变化，带来丝滑重绘
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0, // 默认正方形宫格，后续可替换为 flutter_staggered_grid_view 做真实瀑布流
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final image = images[index];
                        return _buildImageCard(image);
                      },
                      childCount: images.length,
                    ),
                  ),
                );
              },
            ),
            
            // 底部留白，防止被导航栏遮挡
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  // 极简空状态设计
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Icon(Icons.filter_hdr_rounded, size: 64, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              "绝对隐秘，空空如也",
              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // 照片卡片 - 带有大圆角和微动效预留
  Widget _buildImageCard(ImageModel image) {
    return Hero(
      // 为下一阶段的预览页做 Hero 动画准备
      tag: 'hero_image_${image.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Phase 2 接入沉浸式预览页
            print("点击了图片: ${image.filename}");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), // 大圆角
              color: Colors.grey[200], // 加载时的占位底色
              boxShadow:[
                // 极其柔和的弥散阴影，增加微弱的悬浮质感
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              // 后续可升级为 extended_image 提升内存复用率
              child: Image.file(
                File(image.path),
                fit: BoxFit.cover,
                // 防止图片闪烁，加入小渐变
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}