import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import 'photo_import_engine.dart';
import 'photo_preview_page.dart';

// 🚀 新增：筛选条件状态类
class FilterOptions {
  Set<int> ratings = {};
  Set<String> extensions = {};
  String? aspectRatio; // 'landscape' (横), 'portrait' (纵), 'square' (方)

  bool get isEmpty => ratings.isEmpty && extensions.isEmpty && aspectRatio == null;
  
  void clear() {
    ratings.clear();
    extensions.clear();
    aspectRatio = null;
  }
}

class PhotoGalleryView extends StatefulWidget {
  const PhotoGalleryView({super.key});

  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  List<ImageModel> _photos =[];
  bool _isLoading = true;

  // 布局与多选控制
  final List<int> _columnLevels =[2, 3, 4, 5, 8, 16];
  int _currentColIndex = 1; 
  int _baseColIndex = 1;
  final ScrollController _scrollController = ScrollController();

  bool _isSelectingMode = false;
  final ValueNotifier<Set<int>> _selectedIdsNotifier = ValueNotifier({});

  bool _isDragSelecting = false;
  bool _dragSelectModeIsSelecting = true; 
  int? _dragStartIndex; 
  int? _dragCurrentIndex; 
  Set<int> _preDragSelectedIds = {}; 

  // 🚀 新增：当前的筛选条件引擎
  final FilterOptions _filterOptions = FilterOptions();

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedIdsNotifier.dispose();
    super.dispose();
  }

  // 🚀 核心重构：支持 Isar 交叉查询的加载引擎
  Future<void> _loadPhotos() async {
    final db = IsarService.db;
    if (db == null) return;

    setState(() => _isLoading = true);

    List<ImageModel> results =[];

    if (_filterOptions.isEmpty) {
      // 无筛选，极速全量查询
      results = await db.imageModels.where().sortByAddedTimeDesc().findAll();
    } else {
      // 🚀 有筛选：构建 Isar 复合查询树
      var query = db.imageModels.filter().idGreaterThan(-1); // 初始化 Dummy 根节点

      // 1. 评分过滤 (IN 查询)
      if (_filterOptions.ratings.isNotEmpty) {
        query = query.and().anyOf(_filterOptions.ratings, (q, int r) => q.ratingEqualTo(r));
      }

      // 2. 格式过滤 (IN 查询)
      if (_filterOptions.extensions.isNotEmpty) {
        query = query.and().anyOf(_filterOptions.extensions, (q, String ext) => q.extensionEqualTo(ext));
      }

      // 极速拉取符合 DB 规则的数据
      var dbResults = await query.sortByAddedTimeDesc().findAll();

      // 3. 内存二次过滤：画幅比例 (DB 暂不支持字段互相对比)
      if (_filterOptions.aspectRatio != null) {
        dbResults = dbResults.where((p) {
          if (_filterOptions.aspectRatio == 'landscape') return p.width > p.height;
          if (_filterOptions.aspectRatio == 'portrait') return p.width < p.height;
          return p.width == p.height; // square
        }).toList();
      }
      
      results = dbResults;
    }

    setState(() {
      _photos = results;
      _isLoading = false;
    });
  }

  // -------------- 原有神级多选逻辑保持不变 --------------
  void _exitSelection() {
    setState(() {
      _isSelectingMode = false;
      _selectedIdsNotifier.value = {};
    });
    HapticFeedback.lightImpact();
  }

  void _toggleSelectAll() {
    if (_selectedIdsNotifier.value.length == _photos.length) {
      _selectedIdsNotifier.value = {};
    } else {
      _selectedIdsNotifier.value = Set.from(_photos.map((p) => p.id));
    }
    HapticFeedback.selectionClick();
  }

  int? _calculateIndexFromPosition(Offset localPosition) {
    if (_photos.isEmpty) return null;
    final int cols = _columnLevels[_currentColIndex];
    final double spacing = cols >= 8 ? 0.5 : (cols == 4 || cols == 5) ? 1.0 : 4.0;
    final double horizontalPadding = cols >= 4 ? 0.0 : 4.0;
    final double gridWidth = MediaQuery.of(context).size.width - horizontalPadding * 2;
    final double itemWidth = (gridWidth - spacing * (cols - 1)) / cols;
    final double itemHeight = itemWidth;

    double y = localPosition.dy + _scrollController.offset - 8; 
    double x = localPosition.dx - horizontalPadding;
    x = x.clamp(0.0, gridWidth - 1.0);
    y = math.max(0.0, y);

    final int col = (x / (itemWidth + spacing)).floor().clamp(0, cols - 1);
    final int row = (y / (itemHeight + spacing)).floor();
    return (row * cols + col).clamp(0, _photos.length - 1);
  }

  // 🚀 新增：打开现代化筛选面板
  void _openFilterPanel() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 32),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    // 顶部拖拽条
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 24),
                    
                    // 标题区
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        const Text("极客筛选", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setModalState(() => _filterOptions.clear());
                            _loadPhotos(); // 实时刷新画廊
                          },
                          child: const Text("重置", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 1. 星级评分筛选
                    const Text("照片评分", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12, runSpacing: 12,
                      children: List.generate(6, (index) {
                        final isSelected = _filterOptions.ratings.contains(index);
                        return ChoiceChip(
                          label: index == 0 ? const Text("未评分") : Row(mainAxisSize: MainAxisSize.min, children:[Text("$index "), const Icon(LucideIcons.star, size: 14)]),
                          selected: isSelected,
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setModalState(() => selected ? _filterOptions.ratings.add(index) : _filterOptions.ratings.remove(index));
                            _loadPhotos(); 
                          },
                          selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
                          labelStyle: TextStyle(color: isSelected ? const Color(0xFFE70FAD) : Colors.grey.shade800, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? const Color(0xFFE70FAD).withOpacity(0.5) : Colors.transparent)),
                          showCheckmark: false,
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // 2. 画幅比例筛选
                    const Text("画幅比例", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children:[
                        _buildRatioChip('landscape', '横向', LucideIcons.image, setModalState),
                        _buildRatioChip('portrait', '纵向', LucideIcons.smartphone, setModalState),
                        _buildRatioChip('square', '方形', LucideIcons.square, setModalState),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. 扩展名格式筛选
                    const Text("文件格式", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children:['jpg', 'png', 'webp', 'heic'].map((ext) {
                        final isSelected = _filterOptions.extensions.contains(ext);
                        return FilterChip(
                          label: Text(ext.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            setModalState(() => selected ? _filterOptions.extensions.add(ext) : _filterOptions.extensions.remove(ext));
                            _loadPhotos();
                          },
                          selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
                          labelStyle: TextStyle(color: isSelected ? const Color(0xFFE70FAD) : Colors.grey.shade800, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? const Color(0xFFE70FAD).withOpacity(0.5) : Colors.transparent)),
                          showCheckmark: false,
                        );
                      }).toList(),
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

  // 画幅比例的 UI 辅助组件
  Widget _buildRatioChip(String ratioValue, String label, IconData icon, StateSetter setModalState) {
    final isSelected = _filterOptions.aspectRatio == ratioValue;
    return ChoiceChip(
      label: Row(mainAxisSize: MainAxisSize.min, children:[Icon(icon, size: 14, color: isSelected ? const Color(0xFFE70FAD) : Colors.grey), const SizedBox(width: 6), Text(label)]),
      selected: isSelected,
      onSelected: (selected) {
        HapticFeedback.selectionClick();
        setModalState(() => _filterOptions.aspectRatio = selected ? ratioValue : null);
        _loadPhotos();
      },
      selectedColor: const Color(0xFFE70FAD).withOpacity(0.15),
      labelStyle: TextStyle(color: isSelected ? const Color(0xFFE70FAD) : Colors.grey.shade800, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? const Color(0xFFE70FAD).withOpacity(0.5) : Colors.transparent)),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSelectingMode,
      onPopInvoked: (didPop) {
        if (!didPop && _isSelectingMode) _exitSelection(); 
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Stack(
          children:[
            _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE70FAD)))
                : _photos.isEmpty 
                    ? _buildEmptyState() 
                    : _buildGalleryGrid(),
                    
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              bottom: _isSelectingMode ? 0 : -120,
              left: 0,
              right: 0,
              child: _buildSelectionBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _isSelectingMode
          ? IconButton(icon: const Icon(LucideIcons.x, color: Color(0xFF1A1A1A)), onPressed: _exitSelection)
          : null,
      title: ValueListenableBuilder<Set<int>>(
        valueListenable: _selectedIdsNotifier,
        builder: (context, selectedIds, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _isSelectingMode ? '已选择 ${selectedIds.length} 项' : 'Aura',
              key: ValueKey<String>('$_isSelectingMode-${selectedIds.length}'),
              style: TextStyle(fontSize: _isSelectingMode ? 20 : 28, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: const Color(0xFF1A1A1A)),
            ),
          );
        }
      ),
      actions:[
        if (_isSelectingMode)
          ValueListenableBuilder<Set<int>>(
            valueListenable: _selectedIdsNotifier,
            builder: (context, selectedIds, _) {
              return TextButton(
                onPressed: _toggleSelectAll,
                child: Text(selectedIds.length == _photos.length ? '取消全选' : '全选', style: const TextStyle(color: Color(0xFFE70FAD), fontWeight: FontWeight.bold)),
              );
            }
          )
        else ...[
          // 🚀 新增：筛选入口按钮
          Stack(
            alignment: Alignment.center,
            children:[
              IconButton(
                icon: Icon(LucideIcons.listFilter, size: 26, color: _filterOptions.isEmpty ? const Color(0xFF1A1A1A) : const Color(0xFFE70FAD)),
                onPressed: _openFilterPanel,
              ),
              if (!_filterOptions.isEmpty) // 筛选状态红点提示
                Positioned(
                  top: 10, right: 10,
                  child: Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color(0xFFE70FAD), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5))),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(onPressed: () async { await PhotoImportEngine.suckLatestPhoto(); _loadPhotos(); }, icon: const Icon(LucideIcons.plusCircle, size: 28, color: Color(0xFFE70FAD))),
          )
        ]
      ],
    );
  }

  // 🚀 动态空状态提示：智能区分“沙盒为空”与“筛选无结果”
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Icon(LucideIcons.imageOff, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(_filterOptions.isEmpty ? '沙盒空空如也' : '无符合筛选条件的照片', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
          if (!_filterOptions.isEmpty) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() => _filterOptions.clear());
                _loadPhotos();
              },
              icon: const Icon(LucideIcons.refreshCw, size: 16, color: Color(0xFFE70FAD)),
              label: const Text("清除所有筛选", style: TextStyle(color: Color(0xFFE70FAD))),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    final int currentCols = _columnLevels[_currentColIndex];
    final double spacing = currentCols >= 8 ? 0.5 : (currentCols == 4 || currentCols == 5) ? 1.0 : 4.0;
    final double horizontalPadding = currentCols >= 4 ? 0.0 : 4.0;
    final double borderRadius = currentCols >= 4 ? 0.0 : (36.0 / currentCols);

    return Listener(
      onPointerMove: (event) {
        if (_isDragSelecting && _dragStartIndex != null) {
          int? index = _calculateIndexFromPosition(event.localPosition);
          if (index != null && index != _dragCurrentIndex) {
            _dragCurrentIndex = index;
            final newSet = Set<int>.from(_preDragSelectedIds);
            final int start = math.min(_dragStartIndex!, index);
            final int end = math.max(_dragStartIndex!, index);
            for (int i = start; i <= end; i++) {
              final id = _photos[i].id;
              if (_dragSelectModeIsSelecting) { newSet.add(id); } else { newSet.remove(id); }
            }
            if (newSet.length != _selectedIdsNotifier.value.length || !newSet.containsAll(_selectedIdsNotifier.value)) {
              _selectedIdsNotifier.value = newSet;
              HapticFeedback.selectionClick();
            }
          }
        }
      },
      onPointerUp: (_) { _isDragSelecting = false; _dragStartIndex = null; _dragCurrentIndex = null; },
      child: GestureDetector(
        onScaleStart: (details) { if (!_isSelectingMode && details.pointerCount >= 2) _baseColIndex = _currentColIndex; },
        onScaleUpdate: (details) {
          if (!_isSelectingMode && details.pointerCount >= 2) {
            double scale = details.scale;
            int offset = -(math.log(scale) / math.ln2).round();
            int newIndex = (_baseColIndex + offset).clamp(0, _columnLevels.length - 1);
            if (newIndex != _currentColIndex) { setState(() => _currentColIndex = newIndex); HapticFeedback.selectionClick(); }
          }
        },
        child: GridView.builder(
          key: ValueKey<int>(currentCols),
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, bottom: _isSelectingMode ? 120 : 100, top: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: currentCols, mainAxisSpacing: spacing, crossAxisSpacing: spacing),
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            final photo = _photos[index];
            final double checkSize = currentCols >= 5 ? 14.0 : 24.0; 

            return ValueListenableBuilder<Set<int>>(
              valueListenable: _selectedIdsNotifier,
              builder: (context, selectedIds, _) {
                final bool isSelected = selectedIds.contains(photo.id);

                return _PhotoItem(
                  photo: photo, borderRadius: borderRadius, isSelectingMode: _isSelectingMode, isSelected: isSelected, checkSize: checkSize, currentCols: currentCols,
                  onLongPress: () {
                    HapticFeedback.heavyImpact();
                    setState(() { _isSelectingMode = true; final currentSet = Set<int>.from(_selectedIdsNotifier.value); currentSet.add(photo.id); _selectedIdsNotifier.value = currentSet; });
                  },
                  onTapImage: () {
                    Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 300), pageBuilder: (_, __, ___) => PhotoPreviewPage(photos: _photos, initialIndex: index, multiSelectNotifier: _isSelectingMode ? _selectedIdsNotifier : null), transitionsBuilder: (_, animation, __, child) { return FadeTransition(opacity: animation, child: child); }));
                  },
                  onTapCheckbox: () {
                    HapticFeedback.selectionClick();
                    final currentSet = Set<int>.from(_selectedIdsNotifier.value);
                    if (isSelected) currentSet.remove(photo.id); else currentSet.add(photo.id);
                    _selectedIdsNotifier.value = currentSet;
                  },
                  onLongPressCheckboxStart: () {
                    HapticFeedback.lightImpact(); _isDragSelecting = true; _dragStartIndex = index; _dragCurrentIndex = index; _preDragSelectedIds = Set.from(_selectedIdsNotifier.value); _dragSelectModeIsSelecting = !isSelected;
                    final currentSet = Set<int>.from(_preDragSelectedIds);
                    if (_dragSelectModeIsSelecting) currentSet.add(photo.id); else currentSet.remove(photo.id);
                    _selectedIdsNotifier.value = currentSet;
                  },
                );
              }
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectionBottomBar() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(color: const Color(0xFFF6F6F8), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))], borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          _buildBottomAction(LucideIcons.folderPlus, "相册"),
          _buildBottomAction(LucideIcons.tag, "标签"),
          _buildBottomAction(LucideIcons.star, "评分"),
          _buildBottomAction(LucideIcons.trash2, "删除", color: Colors.redAccent),
          _buildBottomAction(LucideIcons.share, "分享"),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, {Color? color}) {
    return Column(mainAxisSize: MainAxisSize.min, children:[Icon(icon, color: color ?? const Color(0xFF1A1A1A), size: 24), const SizedBox(height: 6), Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color ?? Colors.grey.shade800))]);
  }
}

class _PhotoItem extends StatefulWidget {
  final ImageModel photo; final double borderRadius; final bool isSelectingMode; final bool isSelected; final double checkSize; final int currentCols; final VoidCallback onLongPress; final VoidCallback onTapImage; final VoidCallback onTapCheckbox; final VoidCallback onLongPressCheckboxStart;
  const _PhotoItem({required this.photo, required this.borderRadius, required this.isSelectingMode, required this.isSelected, required this.checkSize, required this.currentCols, required this.onLongPress, required this.onTapImage, required this.onTapCheckbox, required this.onLongPressCheckboxStart});
  @override State<_PhotoItem> createState() => _PhotoItemState();
}

class _PhotoItemState extends State<_PhotoItem> {
  bool _isPressed = false;
  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true), onTapUp: (_) => setState(() => _isPressed = false), onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: () { setState(() => _isPressed = false); widget.onLongPress(); }, onTap: widget.onTapImage,
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : 1.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOutCubic,
        child: Stack(
          fit: StackFit.expand,
          children:[
            Hero(tag: widget.photo.path, child: ClipRRect(borderRadius: BorderRadius.circular(widget.borderRadius), child: ExtendedImage.file(File(widget.photo.path), fit: BoxFit.cover, enableMemoryCache: true, clearMemoryCacheWhenDispose: false, cacheWidth: 300))),
            if (widget.isSelected) Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(widget.borderRadius), border: Border.all(color: const Color(0xFFE70FAD), width: widget.currentCols >= 5 ? 1 : 3))),
            if (widget.isSelectingMode) Positioned(right: widget.currentCols >= 5 ? 4 : 8, top: widget.currentCols >= 5 ? 4 : 8, child: GestureDetector(onTap: widget.onTapCheckbox, onLongPressStart: (_) => widget.onLongPressCheckboxStart(), behavior: HitTestBehavior.opaque, child: Padding(padding: const EdgeInsets.all(4.0), child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: widget.checkSize, height: widget.checkSize, decoration: BoxDecoration(color: widget.isSelected ? const Color(0xFFE70FAD) : Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(widget.checkSize / 2.5), border: Border.all(color: Colors.white, width: widget.currentCols >= 5 ? 1 : 2), boxShadow:[if (!widget.isSelected) BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)]), child: widget.isSelected && widget.currentCols < 5 ? const Icon(LucideIcons.check, size: 16, color: Colors.white) : null)))),
          ],
        ),
      ),
    );
  }
}