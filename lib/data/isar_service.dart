import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/image_model.dart';
import 'models/album_model.dart';

class IsarService {
  // 全局单例数据库实例
  static late Isar db;

  // 引擎点火（在 App 刚启动时调用）
  static Future<void> init() async {
    // 获取 Aura 的绝对隐秘沙盒路径 (系统原生相册无法扫描此路径)
    final dir = await getApplicationSupportDirectory(); 
    
    db = await Isar.open([ImageModelSchema, AlbumModelSchema], // 注册我们刚才生成的两张“身份证”
      directory: dir.path,
    );
  }
}