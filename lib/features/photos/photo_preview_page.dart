import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/image_model.dart';
import '../../data/isar_service.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<ImageModel> photos;
  final int initialIndex;
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
    if (!_isSimplifiedMode) {
      setState(() => _isImmersive = !_isImmersive);
    }
  }

  // ==========================================
  // 🚀 极客交互：极简评分引擎 (无废话动效)
  // ==========================================
  void _showRatingSheet(ImageModel photo) {
    HapticFeedback.lightImpact();
    int tempRating = photo.rating ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 32), // 缩减边距
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isSelected = tempRating > index;
                        return GestureDetector(
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            setModalState(() => tempRating = index + 1);
                            // 极客体验：点完直接保存并关闭，无需再点"确认"
                            await IsarService.updateImageRating(photo.id, tempRating);
                            setState(() { photo.rating = tempRating; });
                            if (mounted) Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(
                              isSelected ? Icons.star_rounded : Icons.star_outline_rounded, // 纯净的实体/空心切换
                              size: 42,
                              color: isSelected ? const Color(0xFFE70FAD) : Colors.grey.shade400,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  // ==========================================
  // 🚀 极客交互：全局标签池 (极致丝滑无卡顿版)
  // ==========================================
  void _showTagSheet(ImageModel photo) {
    HapticFeedback.lightImpact();
    List<String> tempTags = List.from(photo.tags ??[]);
    List<String> allGlobalTags =[]; 
    bool isTagsLoaded = false;
    String searchQuery = "";
    final TextEditingController tagController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            
            // 🚀 核心抗掉帧优化：等待 300ms 弹窗动画完全结束后，再进行数据库读取和 UI 刷新
            if (!isTagsLoaded) {
              isTagsLoaded = true;
              Future.delayed(const Duration(milliseconds: 300), () {
                IsarService.getAllUniqueTags().then((tags) {
                  if (mounted) setModalState(() => allGlobalTags = tags);
                });
              });
            }

            // 🚀 核心抗掉帧优化 2：限制最多显示前 30 个匹配的标签，防止 Wrap 瞬间构建几百个节点导致卡死！
            final filteredGlobalTags = allGlobalTags
                .where((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()) && !tempTags.contains(tag))
                .take(30) // 限制渲染数量
                .toList();

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
                decoration: const BoxDecoration(color: Color(0xFFF6F6F8), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: tagController,
                        autofocus: true, 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "搜索或创建标签...",
                          prefixIcon: const Icon(LucideIcons.search, size: 18, color: Colors.grey),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(icon: const Icon(LucideIcons.xCircle, size: 16, color: Colors.grey), onPressed: () { tagController.clear(); setModalState(() => searchQuery = ""); })
                              : null,
                          filled: true, fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        onChanged: (val) => setModalState(() => searchQuery = val),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty && !tempTags.contains(val.trim())) {
                            setModalState(() {
                              tempTags.add(val.trim());
                              if (!allGlobalTags.contains(val.trim())) allGlobalTags.add(val.trim());
                              searchQuery = ""; tagController.clear();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      if (tempTags.isNotEmpty) ...[
                        const Text("已分配", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: tempTags.map((tag) => InkWell(
                            onTap: () { HapticFeedback.selectionClick(); setModalState(() => tempTags.remove(tag)); },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFE70FAD).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text(tag, style: const TextStyle(fontSize: 13, color: Color(0xFFE70FAD), fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(LucideIcons.x, size: 12, color: Color(0xFFE70FAD)),
                                ],
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      const Text("标签库", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 8),
                      
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: allGlobalTags.isEmpty && isTagsLoaded
                            ? const Padding(padding: EdgeInsets.only(top: 10), child: Text("全局库中暂无标签", style: TextStyle(color: Colors.grey, fontSize: 13)))
                            : Wrap(
                                spacing: 6, runSpacing: 6,
                                children:[
                                  if (searchQuery.trim().isNotEmpty && !allGlobalTags.contains(searchQuery.trim()) && !tempTags.contains(searchQuery.trim()))
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setModalState(() {
                                          tempTags.add(searchQuery.trim()); allGlobalTags.add(searchQuery.trim());
                                          tagController.clear(); searchQuery = "";
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE70FAD)), borderRadius: BorderRadius.circular(8)),
                                        child: Text('创建 "$searchQuery"', style: const TextStyle(fontSize: 13, color: Color(0xFFE70FAD), fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  // 这里最多只渲染 30 个，绝对不会卡！
                                  ...filteredGlobalTags.map((tag) => InkWell(
                                    onTap: () { HapticFeedback.selectionClick(); setModalState(() => tempTags.add(tag)); },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                      child: Text(tag, style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A))),
                                    ),
                                  )),
                                ],
                              ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE70FAD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            await IsarService.updateImageTags(photo.id, tempTags);
                            setState(() => photo.tags = tempTags);
                            if (mounted) Navigator.pop(context);
                          },
                          child: const Text("完成", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  // ==========================================
  // 🚀 交互弹窗：详细信息与重命名面板
  // ==========================================
  void _showMoreDetailsSheet(ImageModel photo) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 40),
          decoration: const BoxDecoration(color: Color(0xFFF6F6F8), borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Text("详细信息", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: 弹窗重命名逻辑
                        HapticFeedback.selectionClick();
                      }, 
                      icon: const Icon(LucideIcons.edit3, size: 16, color: Color(0xFFE70FAD)), 
                      label: const Text("重命名", style: TextStyle(color: Color(0xFFE70FAD), fontWeight: FontWeight.bold))
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                // 元数据卡片
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Column(
                    children:[
                      _buildDetailRow(LucideIcons.fileImage, "文件名", photo.filename),
                      const Divider(height: 24, color: Color(0xFFF0F0F0)),
                      _buildDetailRow(LucideIcons.ruler, "分辨率", "${photo.width} × ${photo.height} px"),
                      const Divider(height: 24, color: Color(0xFFF0F0F0)),
                      _buildDetailRow(LucideIcons.hardDrive, "文件大小", "${(photo.sizeBytes / 1024 / 1024).toStringAsFixed(2)} MB"),
                      const Divider(height: 24, color: Color(0xFFF0F0F0)),
                      _buildDetailRow(LucideIcons.calendarClock, "导入时间", DateFormat('yyyy-MM-dd HH:mm').format(photo.addedTime)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 4),
            SizedBox(
              width: 220, // 防止超长文件名溢出
              child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) return const Scaffold();
    final photo = widget.photos[_currentIndex];
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: _isImmersive ? Colors.black : const Color(0xFFF6F6F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children:[
            // 底层核心图片视图 
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
                  color: _isSimplifiedMode ? Colors.transparent : Colors.white.withOpacity(0.8),
                  child: Row(
                    children:[
                      IconButton(
                        icon: Icon(_isSimplifiedMode ? LucideIcons.x : LucideIcons.chevronLeft, size: 28, color: const Color(0xFF1A1A1A)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      Expanded(
                        child: _isSimplifiedMode 
                            ? const SizedBox() 
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(photo.filename, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text("${DateFormat('yyyy-MM-dd HH:mm').format(photo.createdTime)}  |  ${photo.extension.toUpperCase()}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                      ),

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
                                width: 28, height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFE70FAD) : Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10), 
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

            // 底部操作栏 (已装配交互！)
            if (!_isSimplifiedMode)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                bottom: _isImmersive ? -120 : 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white.withOpacity(0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        // TODO: 相册转移在 Phase 2 实现
                        _buildBottomAction(LucideIcons.folderPlus, "相册", onTap: () {}),
                        _buildBottomAction(
                          LucideIcons.tag, "标签", 
                          iconColor: (photo.tags?.isNotEmpty ?? false) ? const Color(0xFFE70FAD) : null,
                          onTap: () => _showTagSheet(photo)
                        ),
                        _buildBottomAction(
                          LucideIcons.star, "评分", 
                          iconColor: (photo.rating ?? 0) > 0 ? const Color(0xFFE70FAD) : null,
                          onTap: () => _showRatingSheet(photo)
                        ),
                        _buildBottomAction(LucideIcons.trash2, "删除", color: Colors.redAccent, onTap: () async {
                          HapticFeedback.heavyImpact();
                          await IsarService.moveToTrash(photo.id);
                          // 临时交互：删除后退回画廊 (后续可优化为平滑切到下一张)
                          if (mounted) Navigator.pop(context); 
                        }),
                        _buildBottomAction(LucideIcons.info, "详情", onTap: () => _showMoreDetailsSheet(photo)),
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

  Widget _buildBottomAction(IconData icon, String label, {Color? color, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Icon(icon, color: iconColor ?? color ?? const Color(0xFF1A1A1A), size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color ?? Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}