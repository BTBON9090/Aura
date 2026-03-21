import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';

class PhotoImportEngine {
  static Future<int> importFromSystemGallery({int? targetAlbumId}) async {
    try {
      print("🚀[Aura引擎] 呼叫系统原生多选相册...");

      final ImagePicker picker = ImagePicker();
      final List<XFile> selectedImages = await picker.pickMultiImage();

      if (selectedImages.isEmpty) {
        print("⚠️[Aura引擎] 用户取消了选择");
        return 0;
      }

      final Directory appDir = await getApplicationSupportDirectory();
      List<ImageModel> newModels = [];

      for (var xfile in selectedImages) {
        final File originFile = File(xfile.path);
        
        // 检查文件是否存在
        if (!await originFile.exists()) {
          print("⚠️ 文件不存在: ${xfile.path}");
          continue;
        }

        final bytes = await originFile.readAsBytes();

        int width = 0;
        int height = 0;

        try {
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          final descriptor = await ui.ImageDescriptor.encoded(buffer);
          width = descriptor.width;
          height = descriptor.height;
          descriptor.dispose();
          buffer.dispose();
          print("📐 解析尺寸: ${xfile.name} -> ${width}x${height}");
        } catch (e) {
          print("⚠️ 尺寸解析失败: ${xfile.name}, 错误: $e");
        }

        // 保留原始文件名
        final String originalFilename = xfile.name;
        final String originalPath = xfile.path;
        final String extension = originalFilename.split('.').last.toLowerCase();
        
        // 使用原始文件名作为存储文件名
        final String sandboxPath = "${appDir.path}/$originalFilename";
        
        // 检查是否已存在同名文件，如果存在则添加时间戳
        String finalPath = sandboxPath;
        String finalFilename = originalFilename;
        if (await File(sandboxPath).exists()) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          finalFilename = "${originalFilename.split('.').first}_$timestamp.$extension";
          finalPath = "${appDir.path}/$finalFilename";
        }

        // 移动文件（而非复制）
        try {
          await originFile.rename(finalPath);
        } catch (e) {
          // 如果跨文件系统移动失败，则复制后删除
          await originFile.copy(finalPath);
          await originFile.delete();
        }

        // 获取文件的实际创建时间（如果可能）
        DateTime createdTime = DateTime.now();
        try {
          final stat = await FileStat.stat(finalPath);
          if (stat.modified != null) {
            createdTime = stat.modified;
          }
        } catch (e) {
          print("⚠️ 无法获取文件时间: $e");
        }

        // 检测是否为截图
        String? sourceApp;
        final nameLower = originalFilename.toLowerCase();
        final pathLower = originalPath.toLowerCase();
        if (nameLower.contains('screenshot') || 
            nameLower.contains('截屏') || 
            nameLower.contains('截图') ||
            pathLower.contains('screenshot')) {
          // 尝试从路径提取来源应用信息
          sourceApp = _extractSourceAppFromPath(originalPath);
        }

        final imageModel = ImageModel()
          ..path = finalPath
          ..filename = finalFilename
          ..extension = extension
          ..originalFilename = originalFilename
          ..originalPath = originalPath
          ..sourceApp = sourceApp
          ..sizeBytes = bytes.length
          ..width = width
          ..height = height
          ..addedTime = DateTime.now()
          ..createdTime = createdTime
          ..modifiedTime = DateTime.now()
          ..rating = 0
          ..tags = []
          ..albumIds = targetAlbumId != null ? [targetAlbumId] : [];

        newModels.add(imageModel);
      }

      await IsarService.db.writeTxn(() async {
        await IsarService.db.imageModels.putAll(newModels);
      });

      print("✅[Aura引擎] 成功导入 ${newModels.length} 张照片！");
      return newModels.length;
    } catch (e) {
      print("❌ 导入失败: $e");
      return 0;
    }
  }

  static String? _extractSourceAppFromPath(String path) {
    // Android 截图路径通常包含包名
    // 例如: /storage/emulated/0/Pictures/Screenshots/com.example.app/
    final parts = path.split('/');
    for (var part in parts) {
      if (part.contains('.') && part.split('.').length >= 2) {
        // 可能是包名格式
        return part;
      }
    }
    return null;
  }
}
