import 'package:isar/isar.dart';

part 'image_model.g.dart';

@collection
class ImageModel {
  Id id = Isar.autoIncrement;

  // 核心路径与名称
  @Index(type: IndexType.hash)
  late String path;
  late String filename;
  
  @Index()
  late String extension;

  // 原始信息（用于详情显示和截图识别）
  String? originalFilename;
  String? originalPath;
  String? sourceApp;

  // PRD 要求的尺寸与大小
  late int sizeBytes;
  late int width;
  late int height;

  // PRD 要求的三大时间维度
  @Index()
  late DateTime addedTime;
  @Index()
  late DateTime createdTime;
  @Index()
  late DateTime modifiedTime;

  // PRD 要求的整理维度
  @Index()
  byte rating = 0;

  @Index()
  List<String> tags = [];

  // PRD 要求的回收站逻辑
  @Index()
  DateTime? deletedTime;

  // 所属的自定义相册关联
  List<int> albumIds = [];

  // PRD 要求的图片描述
  String? description;
}
