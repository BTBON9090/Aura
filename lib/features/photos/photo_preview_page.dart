import 'dart:io';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/image_model.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<ImageModel> photos;
  final int initialIndex;

  const PhotoPreviewPage({super.key, required this.photos, required this.initialIndex});

  @override
  // 🚀 核心引入 1：混入 TickerProviderStateMixin 开启 120Hz 动画引擎
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> with TickerProviderStateMixin {
  late ExtendedPageController _pageController;
  late int _currentIndex;
  bool _isImmersive = false;

  // 🚀 核心引入 2：双击物理阻尼动画控制器
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late void Function() _doubleClickAnimationListener;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = ExtendedPageController(initialPage: _currentIndex);
    
    // 初始化 300 毫秒的顶级跟手动画时钟
    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _doubleClickAnimationController.dispose(); // 释放动画内存
    super.dispose();
  }

  void _toggleImmersive() {
    setState(() {
      _isImmersive = !_isImmersive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photos[_currentIndex];
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: _isImmersive ? Colors.black : const Color(0xFFF6F6F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children:[
            // 1. 核心手势缩放视图
            GestureDetector(
              onTap: _toggleImmersive,
              child: ExtendedImageGesturePageView.builder(
                controller: _pageController,
                itemCount: widget.photos.length,
                // 🚀 核心修复 1：使用 PageScrollPhysics 恢复极速“翻页吸附”特性，并嵌套阻尼保留边缘回弹
                physics: const PageScrollPhysics(), 
                onPageChanged: (int index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.photos[index];
                  return Hero(
                    tag: item.path,
                    child: ExtendedImage.file(
                      File(item.path),
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      enableMemoryCache: true,
                      clearMemoryCacheWhenDispose: false,
                      // 🚀 核心修复 2：偷梁换柱！高精度原图解码时，瞬间调取画廊中已存在的 400px 微缩图垫底！
                      loadStateChanged: (ExtendedImageState state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          // 借用内存中瞬间可取的缩略图（因为 cacheWidth=400 和画廊一致，命中率 100%）
                          return ExtendedImage.file(
                            File(item.path),
                            fit: BoxFit.contain,
                            cacheWidth: 400, 
                            enableLoadState: false, // 防止无限循环
                          );
                        }
                        return null; // 原图解码完成后，自动无缝显示超清原图
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 4.0,
                          animationMaxScale: 4.5,
                          speed: 1.0, // 恢复原本的极速滑动响应
                          inertialSpeed: 150.0,
                          initialScale: 1.0,
                          inPageView: true,
                        );
                      },
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final pointerDownPosition = state.pointerDownPosition;
                        final begin = state.gestureDetails?.totalScale ?? 1.0;
                        final end = begin < 1.5 ? 2.5 : 1.0;

                        _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);
                        _doubleClickAnimationController.stop();
                        _doubleClickAnimationController.reset();

                        _doubleClickAnimationListener = () {
                          state.handleDoubleTap(
                            scale: _doubleClickAnimation!.value,
                            doubleTapPosition: pointerDownPosition,
                          );
                        };

                        _doubleClickAnimation = Tween<double>(begin: begin, end: end).animate(
                          CurvedAnimation(
                            parent: _doubleClickAnimationController, 
                            curve: Curves.easeInOutCubic,
                          ),
                        );
                        _doubleClickAnimation!.addListener(_doubleClickAnimationListener);
                        _doubleClickAnimationController.forward();
                      },
                    ),
                  );
                },
              ),
            ),

            // 顶部操作栏
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: _isImmersive ? -100 : 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    children:[
                      IconButton(
                        icon: const Icon(LucideIcons.chevronLeft, size: 28, color: Color(0xFF1A1A1A)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(
                              photo.filename,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${DateFormat('yyyy-MM-dd HH:mm:ss').format(photo.createdTime)}  |  ${photo.extension.toUpperCase()}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.maximize, color: Color(0xFFE70FAD)),
                        onPressed: _toggleImmersive,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 底部操作栏
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: _isImmersive ? -100 : 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white.withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      _buildBottomAction(LucideIcons.folderPlus, "相册"),
                      _buildBottomAction(LucideIcons.tag, "标签"),
                      _buildBottomAction(LucideIcons.star, "评分"),
                      _buildBottomAction(LucideIcons.trash2, "删除", color: Colors.redAccent),
                      _buildBottomAction(LucideIcons.moreHorizontal, "更多"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:[
        Icon(icon, color: color ?? const Color(0xFF1A1A1A), size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color ?? Colors.grey.shade700)),
      ],
    );
  }
}