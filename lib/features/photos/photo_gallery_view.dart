import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import '../../core/globals.dart'; // 全局状态
import 'photo_import_engine.dart';
import 'photo_preview_page.dart';
import 'photo_action_sheets.dart';

class FilterOptions {
  Set<int> ratings = {};
  Set<String> extensions = {};
  String? aspectRatio;
  bool get isEmpty =>
      ratings.isEmpty && extensions.isEmpty && aspectRatio == null;
  void clear() {
    ratings.clear();
    extensions.clear();
    aspectRatio = null;
  }
}

class PhotoGalleryView extends StatefulWidget {
  final int? albumId; // 如果为 null，则显示全部
  final String? filterType; // 'high_rated', 'screenshots', 'deleted' 等
  final String title; // 页面标题
  const PhotoGalleryView({
    super.key,
    this.albumId,
    this.filterType,
    this.title = 'Aura',
  });
  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState(); //
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  List<ImageModel> _photos = [];
  bool _isLoading = true;

  final List<int> _columnLevels = [2, 3, 4, 5, 8, 16];
  int _currentColIndex = 1;
  int _baseColIndex = 1;

  // 🚀 使用内部滚动监听替代 ScrollController
  double _gridScrollOffset = 0.0;

  bool _isSelectingMode = false;
  final ValueNotifier<Set<int>> _selectedIdsNotifier = ValueNotifier({});

  bool _isDragSelecting = false;
  bool _dragSelectModeIsSelecting = true;
  int? _dragStartIndex;
  int? _dragCurrentIndex;
  Set<int> _preDragSelectedIds = {};

  final FilterOptions _filterOptions = FilterOptions();

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  void dispose() {
    _selectedIdsNotifier.dispose();
    super.dispose();
  }

  // 🚀 核心：加载照片
  Future<void> _loadPhotos() async {
    final db = IsarService.db;
    if (db == null) return;
    // 1. 基础查询：如果是回收站，找已删除的；否则找未删除的
    var query = widget.filterType == 'deleted'
        ? db.imageModels.filter().deletedTimeIsNotNull()
        : db.imageModels.filter().deletedTimeIsNull();

    // 2. 叠加业务筛选
    if (widget.filterType == 'high_rated') {
      query = query.ratingGreaterThan(3); // 评分 > 3 (即4-5分)
    } else if (widget.albumId != null) {
      query = query.albumIdsElementEqualTo(widget.albumId!);
    }

    final photos = await query.sortByAddedTimeDesc().findAll();

    // 3. 根据 filterType 进行特定筛选
    var filteredPhotos = photos;

    // 视频筛选
    if (widget.filterType == 'videos') {
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
      filteredPhotos = filteredPhotos
          .where((p) => videoExtensions.contains(p.extension.toLowerCase()))
          .toList();
    }

    if (widget.filterType == 'screenshots') {
      final screenshotKeywords = [
        'screenshot',
        'screen_shot',
        'screen-shot',
        '截屏',
        '截图',
        '1774104680468074',
      ];
      filteredPhotos = filteredPhotos.where((p) {
        final pathLower = p.path.toLowerCase();
        final nameLower = p.filename.toLowerCase();
        return screenshotKeywords.any(
          (keyword) =>
              pathLower.contains(keyword.toLowerCase()) ||
              nameLower.contains(keyword.toLowerCase()),
        );
      }).toList();
    }

    // 4. 在内存中应用"极客筛选"面板的条件
    if (_filterOptions.ratings.isNotEmpty) {
      filteredPhotos = filteredPhotos
          .where((p) => _filterOptions.ratings.contains(p.rating))
          .toList();
    }

    if (_filterOptions.extensions.isNotEmpty) {
      filteredPhotos = filteredPhotos
          .where(
            (p) =>
                _filterOptions.extensions.contains(p.extension.toLowerCase()),
          )
          .toList();
    }

    if (_filterOptions.aspectRatio != null) {
      final ratio = _filterOptions.aspectRatio;
      if (ratio == 'landscape') {
        filteredPhotos = filteredPhotos
            .where((p) => p.width > p.height)
            .toList();
      } else if (ratio == 'portrait') {
        filteredPhotos = filteredPhotos
            .where((p) => p.height > p.width)
            .toList();
      } else if (ratio == 'square') {
        filteredPhotos = filteredPhotos
            .where((p) => p.width == p.height)
            .toList();
      }
    }

    setState(() {
      _photos = filteredPhotos;
      _isLoading = false;
    });
  }

  void _exitSelection() {
    setState(() {
      _isSelectingMode = false;
      _selectedIdsNotifier.value = {};
    });
    globalMultiSelectNotifier.value = false; // 🚀 通知骨架屏：恢复底部胶囊
    HapticFeedback.lightImpact();
  }

  void _handleDeleteSelected() async {
    final ids = _selectedIdsNotifier.value.toList();
    if (ids.isEmpty) return;

    await PhotoActionSheets.showDeleteConfirm(
      context: context,
      photoIds: ids,
      onDelete: () {
        _exitSelection();
        _loadPhotos();
      },
    );
  }

  void _openAddToAlbumPanel() async {
    final ids = _selectedIdsNotifier.value.toList();
    if (ids.isEmpty) return;

    await PhotoActionSheets.showAlbumPicker(
      context: context,
      photoIds: ids,
      onUpdate: () {
        _exitSelection();
        _loadPhotos();
      },
    );
  }

  void _enterSelection(int initialId) {
    HapticFeedback.heavyImpact();
    setState(() {
      _isSelectingMode = true;
      final currentSet = Set<int>.from(_selectedIdsNotifier.value);
      currentSet.add(initialId);
      _selectedIdsNotifier.value = currentSet;
    });
    globalMultiSelectNotifier.value = true; // 🚀 通知骨架屏：隐藏底部胶囊
  }

  void _toggleSelectAll() {
    if (_selectedIdsNotifier.value.length == _photos.length)
      _selectedIdsNotifier.value = {};
    else
      _selectedIdsNotifier.value = Set.from(_photos.map((p) => p.id));
    HapticFeedback.selectionClick();
  }

  int? _calculateIndexFromPosition(Offset localPosition) {
    if (_photos.isEmpty) return null;
    final int cols = _columnLevels[_currentColIndex];
    final double spacing = cols >= 8
        ? 0.5
        : (cols == 4 || cols == 5)
        ? 1.0
        : 4.0;
    final double horizontalPadding = cols >= 4 ? 0.0 : 4.0;
    final double gridWidth =
        MediaQuery.of(context).size.width - horizontalPadding * 2;
    final double itemWidth = (gridWidth - spacing * (cols - 1)) / cols;
    final double itemHeight = itemWidth;

    // 🚀 使用实时捕获的 _gridScrollOffset 替代 Controller
    double y = localPosition.dy + _gridScrollOffset;
    double x = localPosition.dx - horizontalPadding;
    x = x.clamp(0.0, gridWidth - 1.0);
    y = math.max(0.0, y);

    final int col = (x / (itemWidth + spacing)).floor().clamp(0, cols - 1);
    final int row = (y / (itemHeight + spacing)).floor();
    return (row * cols + col).clamp(0, _photos.length - 1);
  }

  // 筛选面板逻辑保持不变...
  void _openFilterPanel() {
    HapticFeedback.mediumImpact();
    // (此处省略原有的 showModalBottomSheet 内部 UI，请保持你之前复制的版本，如果被截断，可以使用之前正常的筛选面板代码)
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: 32,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF6F6F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "极客筛选",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setModalState(() => _filterOptions.clear());
                        _loadPhotos();
                      },
                      child: const Text(
                        "重置",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 评分
                const Text(
                  "照片评分",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(6, (index) {
                    final isSelected = _filterOptions.ratings.contains(index);
                    return ChoiceChip(
                      label: index == 0
                          ? const Text("未评分")
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("$index "),
                                const Icon(LucideIcons.star, size: 14),
                              ],
                            ),
                      selected: isSelected,
                      onSelected: (selected) {
                        HapticFeedback.selectionClick();
                        setModalState(
                          () => selected
                              ? _filterOptions.ratings.add(index)
                              : _filterOptions.ratings.remove(index),
                        );
                        _loadPhotos();
                      },
                      selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFFE70FAD)
                            : Colors.grey.shade800,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFFE70FAD).withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // 2. 画幅比例筛选
                const Text(
                  "画幅比例",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildRatioChip(
                      'landscape',
                      '横向',
                      LucideIcons.image,
                      setModalState,
                    ),
                    _buildRatioChip(
                      'portrait',
                      '纵向',
                      LucideIcons.smartphone,
                      setModalState,
                    ),
                    _buildRatioChip(
                      'square',
                      '方形',
                      LucideIcons.square,
                      setModalState,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 格式
                const Text(
                  "文件格式",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: ['jpg', 'png', 'webp', 'heic'].map((ext) {
                    final isSelected = _filterOptions.extensions.contains(ext);
                    return FilterChip(
                      label: Text(ext.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        HapticFeedback.selectionClick();
                        setModalState(
                          () => selected
                              ? _filterOptions.extensions.add(ext)
                              : _filterOptions.extensions.remove(ext),
                        );
                        _loadPhotos();
                      },
                      selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFFE70FAD)
                            : Colors.grey.shade800,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFFE70FAD).withOpacity(0.5)
                              : Colors.transparent,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 画幅比例的 UI 辅助组件
  Widget _buildRatioChip(
    String ratioValue,
    String label,
    IconData icon,
    StateSetter setModalState,
  ) {
    final isSelected = _filterOptions.aspectRatio == ratioValue;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? const Color(0xFFE70FAD) : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        HapticFeedback.selectionClick();
        setModalState(
          () => _filterOptions.aspectRatio = selected ? ratioValue : null,
        );
        _loadPhotos();
      },
      selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFE70FAD) : Colors.grey.shade800,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFFE70FAD).withOpacity(0.5)
              : Colors.transparent,
        ),
      ),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSelectingMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSelectingMode) _exitSelection();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F8), // 保持透明，底色由 MainSkeleton 决定
        body: Stack(
          children: [
            // 🚀 核心重构：使用 NestedScrollView 搭载 SliverAppBar
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: const Color(0xFFF6F6F8),
                    surfaceTintColor: Colors.transparent,
                    pinned: true,
                    expandedHeight: 120.0, // 默认大排版高度
                    leading: _isSelectingMode
                        ? IconButton(
                            icon: const Icon(
                              LucideIcons.x,
                              color: Color(0xFF1A1A1A),
                            ),
                            onPressed: _exitSelection,
                          )
                        : null,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(
                        left: _isSelectingMode ? 60 : 20,
                        bottom: 16,
                      ),
                      // 动态标题绑定
                      title: ValueListenableBuilder<Set<int>>(
                        valueListenable: _selectedIdsNotifier,
                        builder: (context, selectedIds, child) {
                          return Text(
                            _isSelectingMode
                                ? '已选择 ${selectedIds.length} 项'
                                : widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: 1.2,
                            ),
                          );
                        },
                      ),
                    ),
                    actions: [
                      if (_isSelectingMode)
                        ValueListenableBuilder<Set<int>>(
                          valueListenable: _selectedIdsNotifier,
                          builder: (context, selectedIds, _) {
                            return TextButton(
                              onPressed: _toggleSelectAll,
                              child: Text(
                                selectedIds.length == _photos.length
                                    ? '取消全选'
                                    : '全选',
                                style: const TextStyle(
                                  color: Color(0xFFE70FAD),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        )
                      else ...[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                LucideIcons.listFilter,
                                size: 26,
                                color: _filterOptions.isEmpty
                                    ? const Color(0xFF1A1A1A)
                                    : const Color(0xFFE70FAD),
                              ),
                              onPressed: _openFilterPanel,
                            ),
                            if (!_filterOptions.isEmpty)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE70FAD),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: const Icon(
                              LucideIcons.plusCircle,
                              size: 28,
                              color: Color(0xFFE70FAD),
                            ),
                            onPressed: () async {
                              int count =
                                  await PhotoImportEngine.importFromSystemGallery(
                                    context,
                                    targetAlbumId: widget.albumId,
                                  );
                              if (count > 0) {
                                _loadPhotos();
                                if (mounted) {
                                  // 🚀 升级为高级导入提示条
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
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
                                            '成功导入 $count 张照片',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: const Duration(seconds: 4),
                                      dismissDirection:
                                          DismissDirection.horizontal,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ];
              },
              // 画廊内容区
              body: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE70FAD),
                      ),
                    )
                  : _photos.isEmpty
                  ? _buildEmptyState()
                  : _buildGalleryGrid(),
            ),

            // 底部多选操作栏
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              bottom: _isSelectingMode ? 0 : -120, // 隐藏时缩到屏幕下方
              left: 0,
              right: 0,
              child: _buildSelectionBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.imageOff, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _filterOptions.isEmpty ? '沙盒空空如也' : '无符合筛选条件的照片',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    final int currentCols = _columnLevels[_currentColIndex];
    final bool useMasonry = currentCols <= 3;
    final double spacing = currentCols >= 8
        ? 0.5
        : (currentCols == 4 || currentCols == 5)
        ? 1.0
        : 4.0;
    final double horizontalPadding = currentCols >= 4 ? 0.0 : 4.0;
    final double borderRadius = currentCols >= 4 ? 0.0 : (36.0 / currentCols);

    Widget gridWidget;

    if (useMasonry) {
      gridWidget = MasonryGridView.count(
        key: ValueKey<int>(currentCols),
        crossAxisCount: currentCols,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: _isSelectingMode ? 120 : 100,
          top: 8,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final photo = _photos[index];
          final double checkSize = currentCols >= 5 ? 14.0 : 24.0;

          return ValueListenableBuilder<Set<int>>(
            valueListenable: _selectedIdsNotifier,
            builder: (context, selectedIds, _) {
              final bool isSelected = selectedIds.contains(photo.id);

              return _PhotoItem(
                photo: photo,
                borderRadius: borderRadius,
                isSelectingMode: _isSelectingMode,
                isSelected: isSelected,
                checkSize: checkSize,
                currentCols: currentCols,
                useMasonry: true,
                onLongPress: () => _enterSelection(photo.id),
                onTapImage: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => PhotoPreviewPage(
                        photos: _photos,
                        initialIndex: index,
                        multiSelectNotifier: _isSelectingMode
                            ? _selectedIdsNotifier
                            : null,
                      ),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ).then((deleted) {
                    if (deleted == true) {
                      _loadPhotos();
                    }
                  });
                },
                onTapCheckbox: () {
                  HapticFeedback.selectionClick();
                  final currentSet = Set<int>.from(_selectedIdsNotifier.value);
                  if (isSelected)
                    currentSet.remove(photo.id);
                  else
                    currentSet.add(photo.id);
                  _selectedIdsNotifier.value = currentSet;
                },
                onLongPressCheckboxStart: () {
                  HapticFeedback.lightImpact();
                  _isDragSelecting = true;
                  _dragStartIndex = index;
                  _dragCurrentIndex = index;
                  _preDragSelectedIds = Set.from(_selectedIdsNotifier.value);
                  _dragSelectModeIsSelecting = !isSelected;
                  final currentSet = Set<int>.from(_preDragSelectedIds);
                  if (_dragSelectModeIsSelecting)
                    currentSet.add(photo.id);
                  else
                    currentSet.remove(photo.id);
                  _selectedIdsNotifier.value = currentSet;
                },
              );
            },
          );
        },
      );
    } else {
      gridWidget = GridView.builder(
        key: ValueKey<int>(currentCols),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: _isSelectingMode ? 120 : 100,
          top: 8,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: currentCols,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final photo = _photos[index];
          final double checkSize = currentCols >= 5 ? 14.0 : 24.0;

          return ValueListenableBuilder<Set<int>>(
            valueListenable: _selectedIdsNotifier,
            builder: (context, selectedIds, _) {
              final bool isSelected = selectedIds.contains(photo.id);

              return _PhotoItem(
                photo: photo,
                borderRadius: borderRadius,
                isSelectingMode: _isSelectingMode,
                isSelected: isSelected,
                checkSize: checkSize,
                currentCols: currentCols,
                useMasonry: false,
                onLongPress: () => _enterSelection(photo.id),
                onTapImage: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => PhotoPreviewPage(
                        photos: _photos,
                        initialIndex: index,
                        multiSelectNotifier: _isSelectingMode
                            ? _selectedIdsNotifier
                            : null,
                      ),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ).then((deleted) {
                    if (deleted == true) {
                      _loadPhotos();
                    }
                  });
                },
                onTapCheckbox: () {
                  HapticFeedback.selectionClick();
                  final currentSet = Set<int>.from(_selectedIdsNotifier.value);
                  if (isSelected)
                    currentSet.remove(photo.id);
                  else
                    currentSet.add(photo.id);
                  _selectedIdsNotifier.value = currentSet;
                },
                onLongPressCheckboxStart: () {
                  HapticFeedback.lightImpact();
                  _isDragSelecting = true;
                  _dragStartIndex = index;
                  _dragCurrentIndex = index;
                  _preDragSelectedIds = Set.from(_selectedIdsNotifier.value);
                  _dragSelectModeIsSelecting = !isSelected;
                  final currentSet = Set<int>.from(_preDragSelectedIds);
                  if (_dragSelectModeIsSelecting)
                    currentSet.add(photo.id);
                  else
                    currentSet.remove(photo.id);
                  _selectedIdsNotifier.value = currentSet;
                },
              );
            },
          );
        },
      );
    }

    return Listener(
      onPointerMove: (event) {
        if (_isDragSelecting && _dragStartIndex != null && !useMasonry) {
          int? index = _calculateIndexFromPosition(event.localPosition);
          if (index != null && index != _dragCurrentIndex) {
            _dragCurrentIndex = index;
            final newSet = Set<int>.from(_preDragSelectedIds);
            final int start = math.min(_dragStartIndex!, index);
            final int end = math.max(_dragStartIndex!, index);
            for (int i = start; i <= end; i++) {
              final id = _photos[i].id;
              if (_dragSelectModeIsSelecting)
                newSet.add(id);
              else
                newSet.remove(id);
            }
            if (newSet.length != _selectedIdsNotifier.value.length ||
                !newSet.containsAll(_selectedIdsNotifier.value)) {
              _selectedIdsNotifier.value = newSet;
              HapticFeedback.selectionClick();
            }
          }
        }
      },
      onPointerUp: (_) {
        _isDragSelecting = false;
        _dragStartIndex = null;
        _dragCurrentIndex = null;
      },
      child: GestureDetector(
        onScaleStart: (details) {
          if (!_isSelectingMode && details.pointerCount >= 2)
            _baseColIndex = _currentColIndex;
        },
        onScaleUpdate: (details) {
          if (!_isSelectingMode && details.pointerCount >= 2) {
            double scale = details.scale;
            int offset = -(math.log(scale) / math.ln2).round();
            int newIndex = (_baseColIndex + offset).clamp(
              0,
              _columnLevels.length - 1,
            );
            if (newIndex != _currentColIndex) {
              setState(() => _currentColIndex = newIndex);
              HapticFeedback.selectionClick();
            }
          }
        },
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            _gridScrollOffset = notification.metrics.pixels;
            return false;
          },
          child: gridWidget,
        ),
      ),
    );
  }

  Widget _buildSelectionBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomAction(
            LucideIcons.folderPlus,
            "相册",
            onTap: _openAddToAlbumPanel,
          ),
          _buildBottomAction(LucideIcons.tag, "标签"),
          _buildBottomAction(LucideIcons.star, "评分"),
          // 🚀 关联删除处理函数
          _buildBottomAction(
            LucideIcons.trash2,
            "删除",
            color: Colors.redAccent,
            onTap: _handleDeleteSelected,
          ),
          _buildBottomAction(LucideIcons.share, "分享"),
        ],
      ),
    );
  }

  Widget _buildBottomAction(
    IconData icon,
    String label, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // 🚀 绑定点击事件
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color ?? const Color(0xFF1A1A1A), size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

// _PhotoItem 保持完全不变
class _PhotoItem extends StatefulWidget {
  final ImageModel photo;
  final double borderRadius;
  final bool isSelectingMode;
  final bool isSelected;
  final double checkSize;
  final int currentCols;
  final bool useMasonry;
  final VoidCallback onLongPress;
  final VoidCallback onTapImage;
  final VoidCallback onTapCheckbox;
  final VoidCallback onLongPressCheckboxStart;
  const _PhotoItem({
    required this.photo,
    required this.borderRadius,
    required this.isSelectingMode,
    required this.isSelected,
    required this.checkSize,
    required this.currentCols,
    required this.useMasonry,
    required this.onLongPress,
    required this.onTapImage,
    required this.onTapCheckbox,
    required this.onLongPressCheckboxStart,
  });
  @override
  State<_PhotoItem> createState() => _PhotoItemState();
}

class _PhotoItemState extends State<_PhotoItem> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    final imageWidget = ExtendedImage.file(
      File(widget.photo.path),
      fit: BoxFit.cover,
      enableMemoryCache: true,
      clearMemoryCacheWhenDispose: false,
      cacheWidth: 300,
    );

    Widget content;
    if (widget.useMasonry) {
      final aspectRatio = widget.photo.width / widget.photo.height;
      final itemWidth =
          (MediaQuery.of(context).size.width - 8) / widget.currentCols - 4;
      final itemHeight = itemWidth / aspectRatio;
      content = SizedBox(
        height: itemHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: imageWidget,
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: imageWidget,
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: () {
        setState(() => _isPressed = false);
        widget.onLongPress();
      },
      onTap: widget.onTapImage,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Stack(
          fit: widget.useMasonry ? StackFit.loose : StackFit.expand,
          children: [
            Hero(tag: widget.photo.path, child: content),
            if (widget.isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: const Color(0xFFE70FAD),
                      width: widget.currentCols >= 5 ? 1 : 3,
                    ),
                  ),
                ),
              ),
            if (widget.isSelectingMode)
              Positioned(
                right: widget.currentCols >= 5 ? 4 : 4, // 5列时调整位置
                top: widget.currentCols >= 5 ? 4 : 4, // 5列时调整位置
                child: GestureDetector(
                  onTap: widget.onTapCheckbox,
                  onLongPressStart: (_) => widget.onLongPressCheckboxStart(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: widget.checkSize,
                      height: widget.checkSize,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? const Color(0xFFE70FAD)
                            : Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          widget.checkSize / 2.5,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: widget.currentCols >= 5 ? 1 : 2,
                        ),
                        boxShadow: [
                          if (!widget.isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                        ],
                      ),
                      child: widget.isSelected && widget.currentCols < 5
                          ? const Icon(
                              LucideIcons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
