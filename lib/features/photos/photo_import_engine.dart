import 'dart:io';
import 'package:image_picker/image_picker.dart'; // 🚀 引入原生多选器
import 'package:path_provider/path_provider.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';

class PhotoImportEngine {
  // 🚀 全新的原生多图导入引擎 (返回成功导入的数量)
  static Future<int> importFromSystemGallery({int? targetAlbumId}) async {
    try {
      print("🚀[Aura引擎] 呼叫系统原生多选相册...");
      
      final ImagePicker picker = ImagePicker();
      // 1. 唤起手机系统原生的极速照片选择器 (支持滑动多选)
      final List<XFile> selectedImages = await picker.pickMultiImage();
      
      if (selectedImages.isEmpty) {
        print("⚠️ [Aura引擎] 用户取消了选择");
        return 0; 
      }

      int successCount = 0;
      final Directory appDir = await getApplicationSupportDirectory();

      // 2. 开启极速数据库批量写入事务
      await IsarService.db.writeTxn(() async {
        for (var xfile in selectedImages) {
          final File originFile = File(xfile.path);
          
          // 3. 构建极其安全的绝对唯一物理沙盒路径
          final String fileName = "aura_${DateTime.now().microsecondsSinceEpoch}_${xfile.name}";
          final String sandboxPath = "${appDir.path}/$fileName";

          // 4. 物理拷贝：真正实现系统相册到 Aura 的隐私隔离
          await originFile.copy(sandboxPath);

          // 5. 发放 Aura 数据库身份证
          final imageModel = ImageModel()
            ..path = sandboxPath
            ..filename = fileName
            ..extension = xfile.name.split('.').last.toLowerCase()
            ..sizeBytes = await originFile.length()
            // 宽高设为 0，我们的 ExtendedImage 渲染引擎会自动自适应
            ..width = 0 
            ..height = 0
            ..addedTime = DateTime.now()
            ..createdTime = DateTime.now() // 原生选择器不提供创建时间，统一使用添加时间
            ..modifiedTime = DateTime.now()
            ..rating = 0
            ..tags =[]
            // 🚀 如果传入了相册ID，直接关联进该相册！
            ..albumIds = targetAlbumId != null ?[targetAlbumId] :[]; 

          // 6. 极速落盘
          await IsarService.db.imageModels.put(imageModel);
          successCount++;
        }
      });

      print("✅ [Aura引擎] 成功吸入并隔离 $successCount 张照片！");
      return successCount;

    } catch (e) {
      print("❌ [Aura引擎] 致命报错: $e");
      return 0;
    }
  }
}