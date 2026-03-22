import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import '../../core/globals.dart'; // 全局状态
import 'photo_gallery_view.dart';

class PhotoActionSheets {
  static int _lastVibratedRating = -1;

  static void showRatingSheet({
    required BuildContext context,
    required ImageModel photo,
    required VoidCallback onUpdate,
  }) {
    HapticFeedback.lightImpact();
    int currentRating = photo.rating;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: 48,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "照片评分",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentRating == 0 ? "滑动或点击以评分" : "$currentRating 星精选",
                      style: TextStyle(
                        fontSize: 13,
                        color: currentRating > 0
                            ? const Color(0xFFE70FAD)
                            : Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) => _handleRatingGesture(
                        details.localPosition.dx,
                        setModalState,
                        (r) => currentRating = r,
                      ),
                      onPanUpdate: (details) => _handleRatingGesture(
                        details.localPosition.dx,
                        setModalState,
                        (r) => currentRating = r,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final bool isSelected = currentRating > index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: AnimatedScale(
                              scale: isSelected ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 40,
                                color: isSelected
                                    ? const Color(0xFFE70FAD)
                                    : Colors.grey.shade400,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            setModalState(() => currentRating = 0);
                            await IsarService.updateImageRating(photo.id, 0);
                            photo.rating = 0;
                            onUpdate();
                            if (context.mounted) Navigator.pop(sheetContext);
                          },
                          child: const Text(
                            "清除",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE70FAD),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () async {
                            HapticFeedback.selectionClick();
                            await IsarService.updateImageRating(
                              photo.id,
                              currentRating,
                            );
                            photo.rating = currentRating;
                            onUpdate();
                            if (context.mounted) Navigator.pop(sheetContext);
                          },
                          child: const Text(
                            "完成",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void _handleRatingGesture(
    double dx,
    StateSetter setModalState,
    Function(int) refRating,
  ) {
    final double starWidth = 64.0;
    int newRating = ((dx + starWidth / 2) / starWidth).ceil().clamp(1, 5);

    if (newRating != _lastVibratedRating) {
      HapticFeedback.selectionClick();
      _lastVibratedRating = newRating;
    }

    setModalState(() => refRating(newRating));
  }

  static Future<void> showAlbumPicker({
    required BuildContext context,
    required List<int> photoIds,
    required VoidCallback onUpdate,
  }) async {
    HapticFeedback.lightImpact();

    final albums = await IsarService.getCustomAlbums();
    if (!context.mounted) return;

    if (albums.isEmpty) {
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
              Icon(LucideIcons.alertCircle, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Text(
                '你还没有自定义相册，请先去相册页新建',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => ConstrainedBox(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 固定头部
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
                      const Text(
                        "加入相册",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
                // 可滚动的相册列表
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    itemCount: albums.length,
                    itemBuilder: (_, index) {
                      final album = albums[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.image,
                            color: Color(0xFFE70FAD),
                          ),
                        ),
                        title: Text(
                          album.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          Navigator.pop(sheetContext);

                          // 检查哪些照片已在目标相册中
                          final existingIds = <int>[];
                          final newIds = <int>[];
                          for (final photoId in photoIds) {
                            final isInAlbum = await IsarService.isPhotoInAlbum(
                              photoId,
                              album.id,
                            );
                            if (isInAlbum) {
                              existingIds.add(photoId);
                            } else {
                              newIds.add(photoId);
                            }
                          }

                          if (newIds.isEmpty) {
                            // 所有照片都已在相册中
                            if (context.mounted) {
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
                                  backgroundColor: Colors.orange,
                                  content: Row(
                                    children: [
                                      const Icon(
                                        LucideIcons.alertCircle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          existingIds.length == 1
                                              ? '图片已存在于「${album.name}」中'
                                              : '所选 ${photoIds.length} 张图片已全部存在于「${album.name}」中',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
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
                            return;
                          }

                          // 添加新照片到相册
                          await IsarService.addPhotosToAlbum(newIds, album.id);
                          onUpdate();
                          globalAlbumRefreshNotifier.value = true; // 通知相册页刷新

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            // 如果有部分照片已存在，显示不同的提示
                            final message = existingIds.isEmpty
                                ? '已装入「${album.name}」'
                                : '已装入 ${newIds.length} 张到「${album.name}」\n${existingIds.length} 张已存在';

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
                                    Expanded(
                                      child: Text(
                                        message,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                action: SnackBarAction(
                                  label: '去查看',
                                  textColor: const Color(0xFFE70FAD),
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).hideCurrentSnackBar();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PhotoGalleryView(
                                          title: album.name,
                                          albumId: album.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                duration: const Duration(seconds: 4),
                                dismissDirection: DismissDirection.horizontal,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showTagSheet({
    required BuildContext context,
    required ImageModel photo,
    required VoidCallback onUpdate,
  }) {
    HapticFeedback.lightImpact();
    List<String> tempTags = List.from(photo.tags ?? []);
    List<String> allGlobalTags = [];
    bool isTagsLoaded = false;
    String searchQuery = "";
    final TextEditingController tagController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            if (!isTagsLoaded) {
              IsarService.getAllUniqueTags().then((tags) {
                if (context.mounted) {
                  setModalState(() {
                    allGlobalTags = tags;
                    isTagsLoaded = true;
                  });
                }
              });
            }

            final filteredTags = searchQuery.isEmpty
                ? allGlobalTags
                : allGlobalTags
                      .where(
                        (t) =>
                            t.toLowerCase().contains(searchQuery.toLowerCase()),
                      )
                      .toList();

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
                      const Text(
                        "标签管理",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: tagController,
                        onChanged: (value) {
                          setModalState(() => searchQuery = value);
                        },
                        decoration: InputDecoration(
                          hintText: "搜索或新建标签...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (tempTags.isNotEmpty) ...[
                        const Text(
                          "已选标签",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tempTags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: const Color(
                                0xFFE70FAD,
                              ).withOpacity(0.1),
                              labelStyle: const TextStyle(
                                color: Color(0xFFE70FAD),
                                fontWeight: FontWeight.bold,
                              ),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              deleteIconColor: const Color(0xFFE70FAD),
                              onDeleted: () {
                                setModalState(() => tempTags.remove(tag));
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text(
                        "全部标签",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: isTagsLoaded
                            ? filteredTags.isEmpty
                                  ? Center(
                                      child: Text(
                                        searchQuery.isEmpty ? "暂无标签" : "无匹配标签",
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: filteredTags.map((tag) {
                                          final isSelected = tempTags.contains(
                                            tag,
                                          );
                                          return FilterChip(
                                            label: Text(tag),
                                            selected: isSelected,
                                            selectedColor: const Color(
                                              0xFFE70FAD,
                                            ).withOpacity(0.15),
                                            checkmarkColor: const Color(
                                              0xFFE70FAD,
                                            ),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: isSelected
                                                    ? const Color(
                                                        0xFFE70FAD,
                                                      ).withOpacity(0.5)
                                                    : Colors.transparent,
                                              ),
                                            ),
                                            onSelected: (selected) {
                                              setModalState(() {
                                                if (selected) {
                                                  tempTags.add(tag);
                                                } else {
                                                  tempTags.remove(tag);
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE70FAD),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () async {
                                HapticFeedback.selectionClick();
                                String newTag = tagController.text.trim();
                                if (newTag.isNotEmpty &&
                                    !tempTags.contains(newTag)) {
                                  tempTags.add(newTag);
                                }
                                await IsarService.updateImageTags(
                                  photo.id,
                                  tempTags,
                                );
                                photo.tags = tempTags;
                                onUpdate();
                                if (context.mounted)
                                  Navigator.pop(sheetContext);
                              },
                              child: const Text(
                                "保存",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> showDeleteConfirm({
    required BuildContext context,
    required List<int> photoIds,
    required VoidCallback onDelete,
  }) async {
    HapticFeedback.heavyImpact();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF6F6F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "移入回收站",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "确定要将 ${photoIds.length} 张照片移入回收站吗？",
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("取消", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "删除",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await IsarService.softDeletePhotos(photoIds);
      onDelete();
    }
  }
}
