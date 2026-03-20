import 'dart:io'; // 🚀 必须加，否则 File 报错
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/image_model.dart';
import 'models/album_model.dart';

class IsarService {
  static late Isar db;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory(); 
    db = await Isar.open(
      [ImageModelSchema, AlbumModelSchema],
      directory: dir.path,
    );
    // 启动后自动执行一次清理
    await cleanExpiredPhotos();
  }

  // --- 事务逻辑区 ---

  // 执行软删除 (移入回收站)
  static Future<void> softDeletePhotos(List<int> ids) async {
    await db.writeTxn(() async {
      for (var id in ids) {
        final photo = await db.imageModels.get(id);
        if (photo != null) {
          photo.deletedTime = DateTime.now();
          await db.imageModels.put(photo);
        }
      }
    });
  }

  // 彻底删除 (物理删除文件 + 数据库记录)
  static Future<void> hardDeletePhotos(List<int> ids) async {
    await db.writeTxn(() async {
      for (var id in ids) {
        final photo = await db.imageModels.get(id);
        if (photo != null) {
          // 1. 物理销毁沙盒中的文件，释放手机空间
          final file = File(photo.path);
          if (await file.exists()) await file.delete();
          // 2. 销毁数据库记录
          await db.imageModels.delete(id);
        }
      }
    });
  }

  // 90天自动清理引擎
  static Future<void> cleanExpiredPhotos() async {
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90));
    
    // 查找已删除且超过 90 天的照片
    final expiredPhotos = await db.imageModels
        .filter()
        .deletedTimeIsNotNull()
        .deletedTimeLessThan(ninetyDaysAgo)
        .findAll();
        
    if (expiredPhotos.isNotEmpty) {
      final ids = expiredPhotos.map((e) => e.id).toList();
      await hardDeletePhotos(ids);
      print('Aura 自动清理：已永久销毁 ${ids.length} 个过期资源');
    }
  }

  // ================= 🚀 自定义相册事务逻辑 =================

  // 1. 创建新相册
  static Future<AlbumModel> createAlbum(String name) async {
    final album = AlbumModel()
      ..name = name
      ..createdAt = DateTime.now();
      
    await db.writeTxn(() async {
      await db.albumModels.put(album);
    });
    return album;
  }

  // 2. 获取所有自定义相册 (按创建时间倒序)
  static Future<List<AlbumModel>> getCustomAlbums() async {
    return await db.albumModels.where().sortByCreatedAtDesc().findAll();
  }

  // 3. 获取某个相册里的照片数量
  static Future<int> getPhotoCountInAlbum(int albumId) async {
    return await db.imageModels.filter()
        .deletedTimeIsNull()
        .albumIdsElementEqualTo(albumId)
        .count();
  }

  // 4. 获取相册封面 (获取该相册下最新添加的一张照片)
  static Future<String?> getAlbumCover(int albumId) async {
    final photo = await db.imageModels.filter()
        .deletedTimeIsNull()
        .albumIdsElementEqualTo(albumId)
        .sortByAddedTimeDesc()
        .findFirst();
    return photo?.path;
  }

  // 5. 将选中的照片批量装入指定的相册
  static Future<void> addPhotosToAlbum(List<int> photoIds, int targetAlbumId) async {
    await db.writeTxn(() async {
      for (var id in photoIds) {
        final photo = await db.imageModels.get(id);
        if (photo != null) {
          // 如果这张照片还不属于这个相册，就加进去
          if (!photo.albumIds.contains(targetAlbumId)) {
            final newAlbumIds = List<int>.from(photo.albumIds);
            newAlbumIds.add(targetAlbumId);
            photo.albumIds = newAlbumIds;
            await db.imageModels.put(photo);
          }
        }
      }
    });
  }

  // ==========================================
  // 🚀 Aura 资产管理核心方法 (Phase 1 补充)
  // ==========================================

  // 1. 更新评分
  static Future<void> updateImageRating(int id, int rating) async {
    if (db == null) return;
    await db!.writeTxn(() async {
      final image = await db!.imageModels.get(id);
      if (image != null) {
        image.rating = rating;
        image.modifiedTime = DateTime.now(); // 触发修改时间更新
        await db!.imageModels.put(image);
      }
    });
  }

  // 2. 更新标签
  static Future<void> updateImageTags(int id, List<String> tags) async {
    if (db == null) return;
    await db!.writeTxn(() async {
      final image = await db!.imageModels.get(id);
      if (image != null) {
        image.tags = tags;
        image.modifiedTime = DateTime.now();
        await db!.imageModels.put(image);
      }
    });
  }

  // 3. 重命名图片
  static Future<void> updateImageName(int id, String newName) async {
    if (db == null) return;
    await db!.writeTxn(() async {
      final image = await db!.imageModels.get(id);
      if (image != null) {
        // 保持扩展名不变
        final ext = image.filename.split('.').last;
        image.filename = newName.contains('.') ? newName : '$newName.$ext';
        image.modifiedTime = DateTime.now();
        await db!.imageModels.put(image);
      }
    });
  }

  // 4. 移入回收站 (软删除)
  static Future<void> moveToTrash(int id) async {
    if (db == null) return;
    await db!.writeTxn(() async {
      final image = await db!.imageModels.get(id);
      if (image != null) {
        // TODO: 依赖 ImageModel 中新增 deletedAt 字段
        // image.deletedAt = DateTime.now();
        // await db!.imageModels.put(image);
        
        // 临时硬删除用于跑通逻辑 (等模型加上 deletedAt 后改为软删除)
        await db!.imageModels.delete(id);
      }
    });
  }

  // ==========================================
  // 🚀 标签与分类统计引擎 (极速防报错版)
  // ==========================================

  static Future<List<String>> getAllUniqueTags() async {
    if (db == null) return[];
    // 仅提取 tags 列，不加载图片对象，规避了 isNull 报错，且性能极高
    final tagsList = await db!.imageModels.where().tagsProperty().findAll();
    final Set<String> uniqueTags = {};
    for (var tags in tagsList) {
      if (tags != null) uniqueTags.addAll(tags);
    }
    final result = uniqueTags.toList();
    result.sort();
    return result;
  }

  static Future<int> getUntaggedCount() async {
    if (db == null) return 0;
    // 同样只查 tags 列，在内存中瞬间统计 null 和空数组的数量
    final tagsList = await db!.imageModels.where().tagsProperty().findAll();
    return tagsList.where((tags) => tags == null || tags.isEmpty).length;
  }
}