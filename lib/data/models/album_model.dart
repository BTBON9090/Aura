import 'package:isar/isar.dart';

part 'album_model.g.dart';

@collection
class AlbumModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name; // 相册名称

  String? coverImagePath; // 相册封面图的本地沙盒路径

  @Index()
  bool isPinned = false; // PRD要求：置顶前 6 个自定义相册

  @Index()
  late DateTime createdAt; // 创建时间，用于排序
}