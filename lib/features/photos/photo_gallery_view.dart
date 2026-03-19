import 'dart:io';
import 'dart:math' as math; // 🚀 核心引入：用于计算完美手感的对数缩放
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import 'photo_import_engine.dart';
import 'photo_preview_page.dart';

class PhotoGalleryView extends StatefulWidget {
  const PhotoGalleryView({super.key});

  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  List<ImageModel> _photos =[];
  bool _isLoading = true;

  // 🚀 核心状态 1：PRD 要求的列数档位
  final List<int> _columnLevels =[2, 3, 4, 5, 8, 16];
  int _currentColIndex = 1; // 默认停留在第 1 档（即 3 列）
  
  // 🚀 核心状态 2：用于记录双指捏合的初始状态
  int _baseColIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final db = IsarService.db;
    if (db != null) {
      final photos = await db.imageModels.where().sortByAddedTimeDesc().findAll();
      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleImport() async {
    bool success = await PhotoImportEngine.suckLatestPhoto();
    if (success) {
      await _loadPhotos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 成功吸入并隔离一张新照片！', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFFE70FAD),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Aura',
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.2,
            color: Color(0xFF1A1A1A)
          ),
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: _handleImport,
              icon: const Icon(LucideIcons.plusCircle, size: 28, color: Color(0xFFE70FAD)),
              tooltip: '吸入最新照片',
            ),
          )
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE70FAD)))
          : _photos.isEmpty 
              ? _buildEmptyState() 
              : _buildGalleryGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Icon(LucideIcons.imageOff, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            '沙盒空空如也',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角 + 号吸入你的第一张私密照片',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // 🚀 终极黑魔法：微观温润（动态圆角），宏观锐利（无缝直角）
  Widget _buildGalleryGrid() {
    final int currentCols = _columnLevels[_currentColIndex];
    
    // 8 列及以上时，间距为 0，否则为 3px
    final double spacing = currentCols >= 8 ? 0.0 : 3.0;
    // 8 列及以上时，消除屏幕左右两侧的留白边界
    final double horizontalPadding = currentCols >= 8 ? 0.0 : 16.0;
    // 🚀 核心动态圆角算法：2-5 列时圆角随列数递减 (如 2列12px, 3列8px...)，8-16 列时彻底变为 0 (直角)
    final double borderRadius = currentCols >= 8 ? 0.0 : (32.0 / currentCols);

    return GestureDetector(
      onScaleStart: (details) {
        if (details.pointerCount >= 2) {
          _baseColIndex = _currentColIndex;
        }
      },
      onScaleUpdate: (details) {
        if (details.pointerCount >= 2) {
          double scale = details.scale;
          int offset = -(math.log(scale) / math.ln2).round();
          int newIndex = (_baseColIndex + offset).clamp(0, _columnLevels.length - 1);

          if (newIndex != _currentColIndex) {
            setState(() {
              _currentColIndex = newIndex;
            });
          }
        }
      },
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, bottom: 100, top: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: currentCols, 
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final photo = _photos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, __, ___) => PhotoPreviewPage(
                    photos: _photos,
                    initialIndex: index,
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Hero(
              tag: photo.path,
              // 🚀 动态圆角裁剪组件重新介入
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: ExtendedImage.file(
                  File(photo.path),
                  fit: BoxFit.cover,
                  enableMemoryCache: true,
                  clearMemoryCacheWhenDispose: false,
                  cacheWidth: 300, 
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}