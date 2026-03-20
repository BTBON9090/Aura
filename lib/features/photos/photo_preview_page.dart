import 'dart:io';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/image_model.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<ImageModel> photos;
  final int initialIndex;
  
  // 🚀 新增：如果传入了这个 Notifier，就代表是从“多选模式”进入的“简易预览”
  final ValueNotifier<Set<int>>? multiSelectNotifier;

  const PhotoPreviewPage({
    super.key, 
    required this.photos, 
    required this.initialIndex,
    this.multiSelectNotifier,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> with TickerProviderStateMixin {
  late ExtendedPageController _pageController;
  late int _currentIndex;
  bool _isImmersive = false;

  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late void Function() _doubleClickAnimationListener;

  bool get _isSimplifiedMode => widget.multiSelectNotifier != null;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = ExtendedPageController(initialPage: _currentIndex);
    
    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _doubleClickAnimationController.dispose();
    super.dispose();
  }

  void _toggleImmersive() {
    // 简易模式下，不支持全屏沉浸（因为顶部需要保留 Checkbox）
    if (!_isSimplifiedMode) {
      setState(() => _isImmersive = !_isImmersive);
    }
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
            // 1. 底层核心图片视图 (完全一致)
            GestureDetector(
              onTap: _toggleImmersive,
              child: ExtendedImageGesturePageView.builder(
                controller: _pageController,
                itemCount: widget.photos.length,
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
                      loadStateChanged: (ExtendedImageState state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return ExtendedImage.file(File(item.path), fit: BoxFit.contain, cacheWidth: 400, enableLoadState: false);
                        }
                        return null; 
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9, maxScale: 4.0, animationMaxScale: 4.5, speed: 1.0, inertialSpeed: 150.0, inPageView: true,
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
                          state.handleDoubleTap(scale: _doubleClickAnimation!.value, doubleTapPosition: pointerDownPosition);
                        };

                        _doubleClickAnimation = Tween<double>(begin: begin, end: end).animate(
                          CurvedAnimation(parent: _doubleClickAnimationController, curve: Curves.easeInOutCubic),
                        );
                        _doubleClickAnimation!.addListener(_doubleClickAnimationListener);
                        _doubleClickAnimationController.forward();
                      },
                    ),
                  );
                },
              ),
            ),

            // 2. 顶部操作栏（智能区分模式）
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: _isImmersive ? -100 : 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  color: _isSimplifiedMode ? Colors.transparent : Colors.white.withOpacity(0.8),
                  child: Row(
                    children:[
                      // 左侧：关闭/返回
                      IconButton(
                        icon: Icon(_isSimplifiedMode ? LucideIcons.x : LucideIcons.chevronLeft, size: 28, color: const Color(0xFF1A1A1A)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      Expanded(
                        child: _isSimplifiedMode 
                            ? const SizedBox() // 简易模式不显示中间信息
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(photo.filename, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text("${DateFormat('yyyy-MM-dd HH:mm:ss').format(photo.createdTime)}  |  ${photo.extension.toUpperCase()}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                      ),

                      // 右侧：全屏按钮 或 多选 Checkbox
                      if (_isSimplifiedMode)
                        ValueListenableBuilder<Set<int>>(
                          valueListenable: widget.multiSelectNotifier!,
                          builder: (context, selectedIds, _) {
                            final bool isSelected = selectedIds.contains(photo.id);
                            return IconButton(
                              onPressed: () {
                                final currentSet = Set<int>.from(selectedIds);
                                if (isSelected) {
                                  currentSet.remove(photo.id);
                                } else {
                                  currentSet.add(photo.id);
                                }
                                widget.multiSelectNotifier!.value = currentSet;
                              },
                              icon: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFE70FAD) : Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10), // 动态大圆角
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: isSelected ? const Icon(LucideIcons.check, size: 18, color: Colors.white) : null,
                              ),
                            );
                          }
                        )
                      else
                        IconButton(icon: const Icon(LucideIcons.maximize, color: Color(0xFFE70FAD)), onPressed: _toggleImmersive),
                    ],
                  ),
                ),
              ),
            ),

            // 3. 底部操作栏（仅普通模式显示）
            if (!_isSimplifiedMode)
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