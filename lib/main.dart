import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
// 引入数据库和刚才写的吸入引擎
import 'data/isar_service.dart';
import 'features/photos/photo_import_engine.dart';

void main() async {
  // 确保系统底层通道建立
  WidgetsFlutterBinding.ensureInitialized();
  // 点火数据库
  await IsarService.init();
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F6F8), // 温润的灰白
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE70FAD), // 我们的魅影紫
          surface: Colors.white,
          onSurface: Color(0xFF1A1A1A),
        ),
      ),
      home: const MainSkeleton(),
    );
  }
}

class MainSkeleton extends StatefulWidget {
  const MainSkeleton({super.key});

  @override
  State<MainSkeleton> createState() => _MainSkeletonState();
}

class _MainSkeletonState extends State<MainSkeleton> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用 Stack 真正实现底部导航栏的“悬浮”，不挤压页面空间
      body: Stack(
        children:[
          // 1. 底层页面内容区
          IndexedStack(
            index: _currentIndex,
            children:[
              _buildPhotoTab(), // 照片测试页
              _buildAlbumTab(), // 相册页
            ],
          ),
          
          // 2. 顶层悬浮胶囊导航栏
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: 148,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    _buildNavItem(0, LucideIcons.image),
                    _buildNavItem(1, LucideIcons.layoutGrid),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 照片 Tab（包含巨大的魅影紫吸入按钮）
  Widget _buildPhotoTab() {
    return Center(
      child: Builder(
        builder: (context) {
          return ElevatedButton.icon(
            onPressed: () async {
              // 触发沙盒吸入引擎
              bool success = await PhotoImportEngine.suckLatestPhoto();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ 一张照片已成功吸入 Aura 沙盒！', style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xFFE70FAD),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(LucideIcons.zap, color: Colors.white),
            label: const Text('吸入最新照片到沙盒', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE70FAD),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 8,
              shadowColor: const Color(0xFFE70FAD).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        }
      ),
    );
  }

  // 相册 Tab
  Widget _buildAlbumTab() {
    return const Center(
      child: Text('相册', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 2)),
    );
  }

  // 底部导航 Icon 微动效
  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = const Color(0xFFB0B0B0);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Icon(
          icon,
          color: isSelected ? activeColor : inactiveColor,
          size: 26,
        ),
      ),
    );
  }
}