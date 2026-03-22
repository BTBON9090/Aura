import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🚀 引入震动反馈
import 'package:lucide_icons/lucide_icons.dart';
// 引入数据库和各个子页面
import 'data/isar_service.dart';
import 'features/photos/photo_gallery_view.dart';
import 'features/albums/albums_view.dart';
import 'core/globals.dart'; // 全局状态

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
        children: [
          // 1. 底层页面内容区
          IndexedStack(
            index: _currentIndex,
            children: [
              PhotoGalleryView(), // Tab 1: 照片
              AlbumsView(), // 🚀 [修改这里] 第二个 Tab：相册入口
            ],
          ),

          // 🚀 核心重构：监听全局多选状态，多选时隐藏底部胶囊
          ValueListenableBuilder<bool>(
            valueListenable: globalMultiSelectNotifier,
            builder: (context, isSelecting, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                // 多选时将整个导航条沉入屏幕外 (-100)，正常时恢复为 0
                bottom: isSelecting ? -100 : 0,
                left: 0,
                right: 0,
                child: child!,
              );
            },
            child: SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter, // 保持居中
                margin: const EdgeInsets.only(bottom: 24),
                child: Container(
                  width: 148,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, LucideIcons.image),
                      _buildNavItem(1, LucideIcons.layoutGrid),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 底部导航 Icon 微动效
  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = const Color(0xFFB0B0B0);

    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          HapticFeedback.lightImpact(); // 🚀 加入极其轻微的切换震动反馈
          setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.12)
              : Colors.transparent,
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
