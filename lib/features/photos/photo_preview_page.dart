import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isFullImmersive = false;

  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late void Function() _doubleClickAnimationListener;

  bool _isLongPressingPrev = false;
  bool _isLongPressingNext = false;

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

  void _enterFullImmersive() {
    if (!_isSimplifiedMode) {
      final currentIndex = _currentIndex;
      setState(() {
        _isFullImmersive = true;
        _isImmersive = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pageController.jumpToPage(currentIndex);
        }
      });
    }
  }

  void _exitFullImmersive() {
    final currentIndex = _currentIndex;
    setState(() => _isFullImmersive = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageController.jumpToPage(currentIndex);
      }
    });
  }

  void _goToPreviousPhoto() {
    if (_currentIndex > 0) {
      final targetIndex = _currentIndex - 1;
      _pageController.jumpToPage(targetIndex);
      setState(() => _currentIndex = targetIndex);
    }
  }

  void _goToNextPhoto() {
    if (_currentIndex < widget.photos.length - 1) {
      final targetIndex = _currentIndex + 1;
      _pageController.jumpToPage(targetIndex);
      setState(() => _currentIndex = targetIndex);
    }
  }

  void _startLongPressPrev() {
    _isLongPressingPrev = true;
    _continuousPrevSwitch();
  }

  void _stopLongPressPrev() {
    _isLongPressingPrev = false;
  }

  void _continuousPrevSwitch() async {
    while (_isLongPressingPrev && _currentIndex > 0) {
      _goToPreviousPhoto();
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  void _startLongPressNext() {
    _isLongPressingNext = true;
    _continuousNextSwitch();
  }

  void _stopLongPressNext() {
    _isLongPressingNext = false;
  }

  void _continuousNextSwitch() async {
    while (_isLongPressingNext && _currentIndex < widget.photos.length - 1) {
      _goToNextPhoto();
      await Future.delayed(const Duration(milliseconds: 150));
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
  // 🚀 更多菜单
  // ==========================================
  void _showMoreMenuSheet(ImageModel photo) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F6F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      _buildMoreMenuItem(
                        icon: LucideIcons.share2,
                        label: "分享",
                        onTap: () {
                          Navigator.pop(context);
                          _sharePhoto(photo);
                        },
                      ),
                      _buildMoreMenuItem(
                        icon: LucideIcons.image,
                        label: "设置为壁纸",
                        onTap: () {
                          Navigator.pop(context);
                          _setAsWallpaper(photo);
                        },
                      ),
                      _buildMoreMenuItem(
                        icon: LucideIcons.maximize2,
                        label: "沉浸式查看",
                        onTap: () {
                          Navigator.pop(context);
                          _enterFullImmersive();
                        },
                      ),
                      _buildMoreMenuItem(
                        icon: LucideIcons.info,
                        label: "详细信息",
                        onTap: () {
                          Navigator.pop(context);
                          _showMoreDetailsSheet(photo);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoreMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF1A1A1A)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _sharePhoto(ImageModel photo) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF2C2C2E),
        content: const Row(
          children: [
            Icon(LucideIcons.info, color: Color(0xFFE70FAD), size: 20),
            SizedBox(width: 12),
            Text(
              '分享功能开发中...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  void _setAsWallpaper(ImageModel photo) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF2C2C2E),
        content: const Row(
          children: [
            Icon(LucideIcons.info, color: Color(0xFFE70FAD), size: 20),
            SizedBox(width: 12),
            Text(
              '壁纸功能开发中...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
      ),
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
                              onTap: () => _openFileLocation(photo.path),
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
                                onTap: () => _openFileLocation(
                                  photo.originalPath!,
                                  isOriginalPath: true,
                                ),
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
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildEditableRatingRow(photo),
                            const Divider(height: 24, color: Color(0xFFF0F0F0)),
                            _buildEditableDescriptionRow(photo),
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

  Widget _buildEditableRatingRow(ImageModel photo) {
    return GestureDetector(
      onTap: () => _showRatingEditor(photo),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.star, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "评分",
                  style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Icon(
                        i <= photo.rating ? LucideIcons.star : LucideIcons.star,
                        size: 20,
                        color: i <= photo.rating
                            ? const Color(0xFFE70FAD)
                            : Colors.grey.shade300,
                      ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDescriptionRow(ImageModel photo) {
    return GestureDetector(
      onTap: () => _showDescriptionEditor(photo),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.alignLeft, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "描述",
                  style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        photo.description?.isNotEmpty == true
                            ? photo.description!
                            : "点击添加描述",
                        style: TextStyle(
                          fontSize: 14,
                          color: photo.description?.isNotEmpty == true
                              ? const Color(0xFF1A1A1A)
                              : Colors.grey.shade400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingEditor(ImageModel photo) {
    HapticFeedback.lightImpact();
    int tempRating = photo.rating;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "评分",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setModalState(() => tempRating = i);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Icon(
                                LucideIcons.star,
                                size: 40,
                                color: i <= tempRating
                                    ? const Color(0xFFE70FAD)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("取消"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _saveRating(photo, tempRating);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE70FAD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "保存",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveRating(ImageModel photo, int rating) async {
    photo.rating = rating;
    await IsarService.db.writeTxn(() async {
      await IsarService.db.imageModels.put(photo);
    });
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2C2C2E),
          content: Row(
            children: [
              const Icon(
                LucideIcons.checkCircle2,
                color: Color(0xFFE70FAD),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "评分已更新为 $rating 星",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    }
  }

  void _showDescriptionEditor(ImageModel photo) {
    final controller = TextEditingController(text: photo.description ?? '');
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  Container(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "描述",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "添加描述...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("取消"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _saveDescription(photo, controller.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE70FAD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "保存",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDescription(ImageModel photo, String description) async {
    photo.description = description.trim().isEmpty ? null : description.trim();
    await IsarService.db.writeTxn(() async {
      await IsarService.db.imageModels.put(photo);
    });
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2C2C2E),
          content: const Row(
            children: [
              Icon(
                LucideIcons.checkCircle2,
                color: Color(0xFFE70FAD),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                "描述已保存",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    }
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
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 100,
                          left: 20,
                          right: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF2C2C2E),
                        content: Row(
                          children: [
                            const Icon(
                              LucideIcons.checkCircle2,
                              color: Color(0xFFE70FAD),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "已重命名为 $newFilename",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 4),
                        dismissDirection: DismissDirection.horizontal,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 100,
                          left: 20,
                          right: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF2C2C2E),
                        content: Row(
                          children: [
                            const Icon(
                              LucideIcons.alertCircle,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "重命名失败: $e",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 4),
                        dismissDirection: DismissDirection.horizontal,
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

  static const _channel = MethodChannel('com.aura.aura/file_utils');

  Future<void> _openFileLocation(
    String path, {
    bool isOriginalPath = false,
  }) async {
    final file = File(path);

    if (await file.exists()) {
      try {
        if (Platform.isAndroid) {
          final result = await _channel.invokeMethod<bool>('openFileLocation', {
            'path': path,
          });
          if (result == true) {
            return;
          }
        } else {
          // iOS/macOS: 使用 url_launcher 打开文件夹
          final directory = file.parent;
          final uri = Uri.parse('file://${directory.path}');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return;
          }
        }
      } catch (e) {
        print("⚠️ 打开文件失败: $e");
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2C2C2E),
          content: Row(
            children: [
              const Icon(
                LucideIcons.folderX,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isOriginalPath ? '原始位置在系统相册中，无法直接访问' : '文件不存在或无法打开',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    }
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    bool isPath = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onTap != null
                        ? const Color(0xFFE70FAD)
                        : const Color(0xFF1A1A1A),
                  ),
                  maxLines: isPath ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onTap != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                LucideIcons.externalLink,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullImmersiveView(ImageModel photo) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _exitFullImmersive();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onTap: _exitFullImmersive,
              child: ExtendedImageGesturePageView.builder(
                controller: _pageController,
                itemCount: widget.photos.length,
                physics: const PageScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.photos[index];
                  return ExtendedImage.file(
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
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _goToPreviousPhoto,
                        onLongPressStart: (_) => _startLongPressPrev(),
                        onLongPressEnd: (_) => _stopLongPressPrev(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.chevronLeft,
                            size: 28,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      Text(
                        "${_currentIndex + 1} / ${widget.photos.length}",
                        style: const TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _goToNextPhoto,
                        onLongPressStart: (_) => _startLongPressNext(),
                        onLongPressEnd: (_) => _stopLongPressNext(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.chevronRight,
                            size: 28,
                            color: Colors.pink,
                          ),
                        ),
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

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) return const Scaffold();
    final photo = widget.photos[_currentIndex];

    if (_isFullImmersive) {
      return _buildFullImmersiveView(photo);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: _isImmersive ? Colors.black : const Color(0xFFF6F6F8),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
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
                            try {
                              await IsarService.softDeletePhotos([photo.id]);
                              debugPrint('删除成功: ${photo.id}');
                              if (mounted) Navigator.pop(context, true);
                            } catch (e) {
                              debugPrint('删除失败: $e');
                            }
                          },
                        ),
                        _buildBottomAction(
                          LucideIcons.moreHorizontal,
                          "更多",
                          onTap: () => _showMoreMenuSheet(photo),
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
