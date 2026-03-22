import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';
import '../../core/globals.dart'; // 全局状态

class PhotoImportEngine {
  static Future<int> importFromSystemGallery(
    BuildContext context, {
    int? targetAlbumId,
  }) async {
    try {
      print("🚀[Aura引擎] 请求相册权限...");

      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth && !ps.hasAccess) {
        print("⚠️[Aura引擎] 相册权限被拒绝");
        return 0;
      }

      print("🚀[Aura引擎] 打开照片选择器...");

      final List<AssetEntity>? selectedAssets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 100,
          requestType: RequestType.image,
          textDelegate: const AssetPickerTextDelegate(),
        ),
      );

      if (selectedAssets == null || selectedAssets.isEmpty) {
        print("⚠️[Aura引擎] 用户取消了选择");
        return 0;
      }

      print("🚀[Aura引擎] 用户选择了 ${selectedAssets.length} 张照片，开始导入...");

      final Directory appDir = await getApplicationSupportDirectory();
      List<ImageModel> newModels = [];

      for (var asset in selectedAssets) {
        final File? originFile = await asset.originFile;
        if (originFile == null) {
          print("⚠️ 无法获取原始文件: ${asset.id}");
          continue;
        }

        final bytes = await originFile.readAsBytes();

        int width = asset.width;
        int height = asset.height;

        if (width == 0 || height == 0) {
          try {
            final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
            final descriptor = await ui.ImageDescriptor.encoded(buffer);
            width = descriptor.width;
            height = descriptor.height;
            descriptor.dispose();
            buffer.dispose();
          } catch (e) {
            print("⚠️ 尺寸解析失败: ${asset.id}, 错误: $e");
          }
        }

        final String originalFilename = await asset.titleAsync;
        final String? realPath = asset.relativePath;
        final String extension = (asset.title?.split('.').last ?? 'jpg')
            .toLowerCase();

        String finalPath = "${appDir.path}/$originalFilename";
        String finalFilename = originalFilename;

        int counter = 1;
        while (await File(finalPath).exists()) {
          final nameWithoutExt = originalFilename.split('.').first;
          finalFilename = "${nameWithoutExt}_$counter.$extension";
          finalPath = "${appDir.path}/$finalFilename";
          counter++;
        }

        await File(finalPath).writeAsBytes(bytes);

        DateTime createdTime = asset.createDateTime;
        if (createdTime.year == 1970) {
          createdTime = DateTime.now();
        }

        String? sourceApp;
        final nameLower = originalFilename.toLowerCase();
        if (nameLower.contains('screenshot') ||
            nameLower.contains('截屏') ||
            nameLower.contains('截图')) {
          if (realPath != null) {
            sourceApp = _extractSourceAppFromPath(realPath);
          }
        }

        final imageModel = ImageModel()
          ..path = finalPath
          ..filename = finalFilename
          ..extension = extension
          ..originalFilename = originalFilename
          ..originalPath = realPath ?? originFile.path
          ..sourceApp = sourceApp
          ..sizeBytes = bytes.length
          ..width = width
          ..height = height
          ..addedTime = DateTime.now()
          ..createdTime = createdTime
          ..modifiedTime = asset.modifiedDateTime.year > 1970
              ? asset.modifiedDateTime
              : DateTime.now()
          ..rating = 0
          ..tags = []
          ..albumIds = targetAlbumId != null ? [targetAlbumId] : [];

        newModels.add(imageModel);
        print("✅ 导入: $originalFilename (${width}x${height})");
      }

      await IsarService.db.writeTxn(() async {
        await IsarService.db.imageModels.putAll(newModels);
      });

      if (targetAlbumId != null) {
        globalAlbumRefreshNotifier.value = true; // 通知相册页刷新
      }

      print("✅[Aura引擎] 成功导入 ${newModels.length} 张照片！");
      return newModels.length;
    } catch (e, stack) {
      print("❌ 导入失败: $e");
      print("Stack: $stack");
      return 0;
    }
  }

  static String? _extractSourceAppFromPath(String path) {
    final parts = path.split('/');
    for (var part in parts) {
      if (part.contains('.') && part.split('.').length >= 2) {
        return part;
      }
    }
    return null;
  }
}
