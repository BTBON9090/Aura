import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/image_model.dart';
import '../../data/isar_service.dart';
import 'photo_action_sheets.dart';

class PhotoPreviewPage extends StatefulWidget {
  final List<ImageModel> photos;
  final int initialIndex;
  final ValueNotifier<Set<int>>? multiSelectNotifier;
  final VoidCallback? onDelete;

  const PhotoPreviewPage({
    super.key,
    required this.photos,
    required this.initialIndex,
    this.multiSelectNotifier,
    this.onDelete,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage>
    with TickerProviderStateMixin {
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

  void _showRatingSheet(ImageModel photo) {
    PhotoActionSheets.showRatingSheet(
      context: context,
      photo: photo,
      onUpdate: () => setState(() {}),
    );
  }

  void _showTagSheet(ImageModel photo) {
    PhotoActionSheets.showTagSheet(
      context: context,
      photo: photo,
      onUpdate: () => setState(() {}),
    );
  }

  void _showAlbumPicker(ImageModel photo) {
    PhotoActionSheets.showAlbumPicker(
      context: context,
      photoIds: [photo.id],
      onUpdate: () => setState(() {}),
    );
  }

  // ==========================================
  // 🚀 交互弹窗：详细信息与重命名面板
  // ==========================================
  void _showMoreDetailsSheet(ImageModel photo) async {
    HapticFeedback.lightImpact();

    // 获取照片所在的相册名称
    final albumNames = await IsarService.getAlbumNamesForPhoto(photo.albumIds);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F6F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 固定的头部
                  Container(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 12,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "详细信息",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showRenameDialog(photo),
                              icon: const Icon(
                                LucideIcons.edit3,
                                size: 16,
                                color: Color(0xFFE70FAD),
                              ),
                              label: const Text(
                                "重命名",
                                style: TextStyle(
                                  color: Color(0xFFE70FAD),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 可滚动的内容
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              LucideIcons.fileImage,
                              "文件名",
                              photo.filename,
                            ),
                            if (photo.originalFilename != null &&
                                photo.originalFilename != photo.filename) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.fileText,
                                "原始文件名",
                                photo.originalFilename!,
                              ),
                            ],
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.folderOpen,
                              "存储位置",
                              photo.path,
                              isPath: true,
                            ),
                            if (photo.originalPath != null) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.folder,
                                "原始位置",
                                photo.originalPath!,
                                isPath: true,
                              ),
                            ],
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.ruler,
                              "分辨率",
                              "${photo.width} × ${photo.height} px",
                            ),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.hardDrive,
                              "文件大小",
                              "${(photo.sizeBytes / 1024 / 1024).toStringAsFixed(2)} MB",
                            ),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.fileType,
                              "文件类型",
                              photo.extension.toUpperCase(),
                            ),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.calendarPlus,
                              "拍摄时间",
                              DateFormat(
                                'yyyy-MM-dd HH:mm:ss',
                              ).format(photo.createdTime),
                            ),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.calendarClock,
                              "导入时间",
                              DateFormat(
                                'yyyy-MM-dd HH:mm:ss',
                              ).format(photo.addedTime),
                            ),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildDetailRow(
                              LucideIcons.calendarCheck,
                              "修改时间",
                              DateFormat(
                                'yyyy-MM-dd HH:mm:ss',
                              ).format(photo.modifiedTime),
                            ),
                            if (photo.sourceApp != null) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.smartphone,
                                "截图来源",
                                photo.sourceApp!,
                              ),
                            ],
                            if (albumNames.isNotEmpty) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.folderHeart,
                                "所在相册",
                                albumNames.join('、'),
                              ),
                            ],
                            if (photo.rating > 0) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.star,
                                "评分",
                                "${photo.rating} 星",
                              ),
                            ],
                            if (photo.tags.isNotEmpty) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.tag,
                                "标签",
                                photo.tags.join(', '),
                              ),
                            ],
                            if (photo.description != null &&
                                photo.description!.isNotEmpty) ...[
                              const Divider(
                                height: 24,
                                color: Color(0xFFF0F0F0),
                              ),
                              _buildDetailRow(
                                LucideIcons.alignLeft,
                                "描述",
                                photo.description!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRenameDialog(ImageModel photo) {
    final controller = TextEditingController(text: photo.filename);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "重命名",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "输入新文件名",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE70FAD),
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isEmpty || newName == photo.filename) {
                  Navigator.pop(context);
                  return;
                }

                String newFilename = newName;
                if (!newName.contains('.')) {
                  newFilename = "$newName.${photo.extension}";
                }

                try {
                  final oldFile = File(photo.path);
                  final dir = oldFile.parent.path;
                  final newPath = "$dir/$newFilename";

                  if (await oldFile.exists()) {
                    await oldFile.rename(newPath);
                  }

                  photo.filename = newFilename;
                  photo.path = newPath;
                  photo.modifiedTime = DateTime.now();

                  await IsarService.db.writeTxn(() async {
                    await IsarService.db.imageModels.put(photo);
                  });

                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("已重命名为 $newFilename"),
                        backgroundColor: const Color(0xFFE70FAD),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("重命名失败: $e"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE70FAD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "确定",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    bool isPath = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: isPath ? 3 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
          children: [
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
                          return ExtendedImage.file(
                            File(item.path),
                            fit: BoxFit.contain,
                            cacheWidth: 400,
                            enableLoadState: false,
                          );
                        }
                        return null;
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          maxScale: 4.0,
                          animationMaxScale: 4.5,
                          speed: 1.0,
                          inertialSpeed: 150.0,
                          inPageView: true,
                        );
                      },
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final pointerDownPosition = state.pointerDownPosition;
                        final begin = state.gestureDetails?.totalScale ?? 1.0;
                        final end = begin < 1.5 ? 2.5 : 1.0;

                        _doubleClickAnimation?.removeListener(
                          _doubleClickAnimationListener,
                        );
                        _doubleClickAnimationController.stop();
                        _doubleClickAnimationController.reset();

                        _doubleClickAnimationListener = () {
                          state.handleDoubleTap(
                            scale: _doubleClickAnimation!.value,
                            doubleTapPosition: pointerDownPosition,
                          );
                        };

                        _doubleClickAnimation =
                            Tween<double>(begin: begin, end: end).animate(
                              CurvedAnimation(
                                parent: _doubleClickAnimationController,
                                curve: Curves.easeInOutCubic,
                              ),
                            );
                        _doubleClickAnimation!.addListener(
                          _doubleClickAnimationListener,
                        );
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  color: _isSimplifiedMode
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isSimplifiedMode
                              ? LucideIcons.x
                              : LucideIcons.chevronLeft,
                          size: 28,
                          color: const Color(0xFF1A1A1A),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),

                      Expanded(
                        child: _isSimplifiedMode
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    photo.filename,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${DateFormat('yyyy-MM-dd HH:mm').format(photo.createdTime)}  |  ${photo.extension.toUpperCase()}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      if (_isSimplifiedMode)
                        ValueListenableBuilder<Set<int>>(
                          valueListenable: widget.multiSelectNotifier!,
                          builder: (context, selectedIds, _) {
                            final bool isSelected = selectedIds.contains(
                              photo.id,
                            );
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
                                  color: isSelected
                                      ? const Color(0xFFE70FAD)
                                      : Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        LucideIcons.check,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            );
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(
                            LucideIcons.maximize,
                            color: Color(0xFFE70FAD),
                          ),
                          onPressed: _toggleImmersive,
                        ),
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
                      children: [
                        _buildBottomAction(
                          LucideIcons.folderPlus,
                          "相册",
                          onTap: () => _showAlbumPicker(photo),
                        ),
                        _buildBottomAction(
                          LucideIcons.tag,
                          "标签",
                          iconColor: (photo.tags?.isNotEmpty ?? false)
                              ? const Color(0xFFE70FAD)
                              : null,
                          onTap: () => _showTagSheet(photo),
                        ),
                        _buildBottomAction(
                          LucideIcons.star,
                          "评分",
                          iconColor: (photo.rating ?? 0) > 0
                              ? const Color(0xFFE70FAD)
                              : null,
                          onTap: () => _showRatingSheet(photo),
                        ),
                        _buildBottomAction(
                          LucideIcons.trash2,
                          "删除",
                          color: Colors.redAccent,
                          onTap: () async {
                            HapticFeedback.heavyImpact();
                            await IsarService.moveToTrash(photo.id);
                            // 临时交互：删除后退回画廊 (后续可优化为平滑切到下一张)
                            if (mounted) Navigator.pop(context);
                          },
                        ),
                        _buildBottomAction(
                          LucideIcons.info,
                          "详情",
                          onTap: () => _showMoreDetailsSheet(photo),
                        ),
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

  Widget _buildBottomAction(
    IconData icon,
    String label, {
    Color? color,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? color ?? const Color(0xFF1A1A1A),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
