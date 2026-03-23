import 'dart:io'; // 🚀 必须加，否则 File 报错
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/image_model.dart';
import 'models/album_model.dart';
import 'models/tag_model.dart';
import 'models/tag_group_model.dart';

class IsarService {
  static late Isar db;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    db = await Isar.open([
      ImageModelSchema,
      AlbumModelSchema,
      TagModelSchema,
      TagGroupModelSchema,
    ], directory: dir.path);
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
    return await db.imageModels
        .filter()
        .deletedTimeIsNull()
        .albumIdsElementEqualTo(albumId)
        .count();
  }

  // 4. 获取相册封面 (获取该相册下最新添加的一张照片)
  static Future<String?> getAlbumCover(int albumId) async {
    final photo = await db.imageModels
        .filter()
        .deletedTimeIsNull()
        .albumIdsElementEqualTo(albumId)
        .sortByAddedTimeDesc()
        .findFirst();
    return photo?.path;
  }

  // 5. 将选中的照片批量装入指定的相册
  static Future<void> addPhotosToAlbum(
    List<int> photoIds,
    int targetAlbumId,
  ) async {
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

  // 6. 获取照片所在的相册名称列表
  static Future<List<String>> getAlbumNamesForPhoto(List<int> albumIds) async {
    if (albumIds.isEmpty) return [];
    final albums = await db.albumModels
        .where()
        .anyOf(albumIds, (q, id) => q.idEqualTo(id))
        .findAll();
    return albums.map((a) => a.name).toList();
  }

  // 7. 检查照片是否已在某个相册中
  static Future<bool> isPhotoInAlbum(int photoId, int albumId) async {
    final photo = await db.imageModels.get(photoId);
    return photo?.albumIds.contains(albumId) ?? false;
  }

  // ================= 🚀 资产元数据更新事务 =================

  // 1. 极速更新照片评分 (0-5分)
  static Future<void> updateImageRating(int imageId, int newRating) async {
    await db.writeTxn(() async {
      final photo = await db.imageModels.get(imageId);
      if (photo != null) {
        photo.rating = newRating; // 写入新评分
        await db.imageModels.put(photo);
      }
    });
  }

  // ================= 🚀 资产元数据更新事务 =================
  // （如果你之前写过 updateImageRating，就紧跟在它下面）

  // 2. 更新照片的标签数组
  static Future<void> updateImageTags(int imageId, List<String> newTags) async {
    await db.writeTxn(() async {
      final photo = await db.imageModels.get(imageId);
      if (photo != null) {
        photo.tags = newTags; // 覆盖新标签
        await db.imageModels.put(photo);
      }
    });
  }

  // 3. 超光速全库扫描：获取当前存在的所有唯一标签 (用于搜索联想)
  static Future<List<String>> getAllUniqueTags() async {
    // 找出所有没被删除的照片
    final photos = await db.imageModels.filter().deletedTimeIsNull().findAll();
    final Set<String> uniqueTags = {};

    for (var photo in photos) {
      if (photo.tags != null) {
        uniqueTags.addAll(photo.tags!);
      }
    }

    final sortedTags = uniqueTags.toList();
    // 按首字母字典序排列
    sortedTags.sort((a, b) => a.compareTo(b));
    return sortedTags;
  }

  // 4. 获取没有任何标签的“未分类照片”数量
  static Future<int> getUntaggedCount() async {
    final photos = await db.imageModels.filter().deletedTimeIsNull().findAll();
    // 找出 tags 数组为空或者 null 的照片
    return photos.where((p) => p.tags == null || p.tags!.isEmpty).length;
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

  // ================= 🚀 标签分组事务逻辑 =================

  static Future<int> createTagGroup(String name) async {
    final group = TagGroupModel()
      ..name = name
      ..createdTime = DateTime.now();

    return await db.writeTxn(() async {
      return await db.tagGroupModels.put(group);
    });
  }

  static Future<List<TagGroupModel>> getAllTagGroups() async {
    return await db.tagGroupModels.where().sortByCreatedTimeDesc().findAll();
  }

  static Future<void> deleteTagGroup(int groupId) async {
    await db.writeTxn(() async {
      final tags = await db.tagModels
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();
      for (var tag in tags) {
        tag.groupId = null;
        await db.tagModels.put(tag);
      }
      await db.tagGroupModels.delete(groupId);
    });
  }

  static Future<int> getTagCountInGroup(int groupId) async {
    return await db.tagModels.filter().groupIdEqualTo(groupId).count();
  }

  // ================= 🚀 标签事务逻辑 =================

  static Future<int> createTag(
    String name, {
    int? groupId,
    bool isFrequentlyUsed = false,
  }) async {
    final tag = TagModel()
      ..name = name
      ..groupId = groupId
      ..isFrequentlyUsed = isFrequentlyUsed
      ..createdTime = DateTime.now()
      ..modifiedTime = DateTime.now();

    return await db.writeTxn(() async {
      return await db.tagModels.put(tag);
    });
  }

  static Future<List<TagModel>> getAllTags() async {
    return await db.tagModels.where().sortByModifiedTimeDesc().findAll();
  }

  static Future<List<TagModel>> getTagsSortedByName() async {
    return await db.tagModels.where().sortByName().findAll();
  }

  static Future<List<TagModel>> getUngroupedTags() async {
    return await db.tagModels
        .filter()
        .groupIdIsNull()
        .sortByModifiedTimeDesc()
        .findAll();
  }

  static Future<List<TagModel>> getFrequentlyUsedTags() async {
    return await db.tagModels
        .filter()
        .isFrequentlyUsedEqualTo(true)
        .sortByModifiedTimeDesc()
        .findAll();
  }

  static Future<List<TagModel>> getTagsInGroup(int groupId) async {
    return await db.tagModels
        .filter()
        .groupIdEqualTo(groupId)
        .sortByModifiedTimeDesc()
        .findAll();
  }

  static Future<void> updateTag(
    int tagId, {
    String? name,
    int? groupId,
    bool? isFrequentlyUsed,
    bool clearGroup = false,
  }) async {
    await db.writeTxn(() async {
      final tag = await db.tagModels.get(tagId);
      if (tag != null) {
        if (name != null) tag.name = name;
        if (clearGroup) {
          tag.groupId = null;
        } else if (groupId != null) {
          tag.groupId = groupId;
        }
        if (isFrequentlyUsed != null) tag.isFrequentlyUsed = isFrequentlyUsed;
        tag.modifiedTime = DateTime.now();
        await db.tagModels.put(tag);
      }
    });
  }

  static Future<void> deleteTag(int tagId) async {
    await db.writeTxn(() async {
      final tag = await db.tagModels.get(tagId);
      if (tag != null) {
        final photos = await db.imageModels
            .filter()
            .tagsElementContains(tag.name)
            .findAll();
        for (var photo in photos) {
          photo.tags.remove(tag.name);
          await db.imageModels.put(photo);
        }
        await db.tagModels.delete(tagId);
      }
    });
  }

  static Future<int> getPhotoCountWithTag(String tagName) async {
    return await db.imageModels
        .filter()
        .deletedTimeIsNull()
        .tagsElementContains(tagName)
        .count();
  }

  static Future<List<ImageModel>> getPhotosWithTag(String tagName) async {
    return await db.imageModels
        .filter()
        .deletedTimeIsNull()
        .tagsElementContains(tagName)
        .findAll();
  }
}
