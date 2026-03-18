import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/isar_service.dart';
import '../../data/models/image_model.dart';

class PhotoImportEngine {
  static Future<bool> suckLatestPhoto() async {
    try {
      print("🚀 [Aura引擎] 开始吸入照片流程...");
      
      // 1. 先请求 PhotoManager 权限（它内部会处理跨平台权限逻辑）
      print("🔍 [Aura引擎] 正在请求 PhotoManager 核心权限...");
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      
      // 详细打印权限状态以便调试
      print("📋 [Aura引擎] PhotoManager 权限状态: hasAccess=${ps.hasAccess}, isAuth=${ps.isAuth}, isLimited=${ps.isLimited}");
      
      // 检查权限状态
      if (!ps.hasAccess && !ps.isAuth) {
        print("❌ [Aura引擎] PhotoManager 核心权限获取失败！");
        
        // 检查是否需要打开设置页
        if (ps == PermissionState.denied) {
          print("⚠️ [Aura引擎] 权限被拒绝，正在引导跳往设置页...");
          await openAppSettings();
        }
        return false;
      }
      
      // 对于 limited 权限，我们也可以继续尝试
      if (ps.isLimited) {
        print("⚠️ [Aura引擎] 仅获得部分照片访问权限，尝试继续...");
      }

      print("✅ [Aura引擎] 权限突破成功！开始扫描图库...");

      // 2. 获取手机里的“全部照片”相册
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);
      if (paths.isEmpty) return false;
      
      // 拿到最新的一张图
      final List<AssetEntity> photos = await paths[0].getAssetListPaged(page: 0, size: 1);
      if (photos.isEmpty) return false;
      final AssetEntity original = photos.first;

      // 3. 获取真实物理文件
      final File? originFile = await original.originFile;
      if (originFile == null) return false;

      // 4. 构建绝对沙盒路径
      final Directory appDir = await getApplicationSupportDirectory();
      final String fileName = "aura_${DateTime.now().millisecondsSinceEpoch}_${original.title ?? 'img.jpg'}";
      final String sandboxPath = "${appDir.path}/$fileName";

      // 5. 核心动作：物理隔离 Copy
      await originFile.copy(sandboxPath);

      // 6. 发放 Aura 数据库身份证
      final imageModel = ImageModel()
        ..path = sandboxPath
        ..filename = fileName
        ..extension = fileName.split('.').last.toLowerCase()
        ..sizeBytes = await originFile.length()
        ..width = original.width
        ..height = original.height
        ..addedTime = DateTime.now()
        ..createdTime = original.createDateTime
        ..modifiedTime = original.modifiedDateTime
        ..rating = 0
        ..tags =[];

      // 7. 写入数据库
      await IsarService.db?.writeTxn(() async {
        await IsarService.db?.imageModels.put(imageModel);
      });

      print("✅ [Aura引擎] 成功吸入照片并隔离！");
      print("📂 沙盒隐秘路径: $sandboxPath");
      return true;

    } catch (e) {
      print("❌ [Aura引擎] 致命报错: $e");
      return false;
    }
  }
}