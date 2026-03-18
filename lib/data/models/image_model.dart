import 'package:isar/isar.dart';

// 报错不用管，下一步运行命令后会自动生成这个文件
part 'image_model.g.dart';

@collection
class ImageModel {
  Id id = Isar.autoIncrement;

  // 核心路径与名称
  @Index(type: IndexType.hash)
  late String path; // Aura 沙盒内部的物理路径
  late String filename; // 文件名 (支持在 App 内重命名)
  
  @Index()
  late String extension; // 扩展名 e.g., 'jpg', 'png', 'mp4'

  // PRD 要求的尺寸与大小 (用于自动归类：横向、纵向、方形、文件大小范围)
  late int sizeBytes; // 文件字节大小
  late int width;     // 像素宽
  late int height;    // 像素高

  // PRD 要求的三大时间维度 (全部加索引，保证 10 万张图瞬间范围筛选)
  @Index()
  late DateTime addedTime;   // 移入 Aura 的时间
  @Index()
  late DateTime createdTime; // 照片原始拍摄/创建时间
  @Index()
  late DateTime modifiedTime;// 文件修改时间

  // PRD 要求的整理维度
  @Index()
  byte rating = 0; // 0-5 评分

  @Index()
  List<String> tags =[]; // 标签数组，支持多重标签交叉查询

  // PRD 要求的回收站逻辑 (90天内可恢复)
  @Index()
  DateTime? deletedTime; // 为空表示正常图片；有值表示已删除，记录删除发生的时间

  // 所属的自定义相册关联 (一张图片可以存在于多个自定义相册中)
  List<int> albumIds =[]; // 一张图片可以存在于多个相册，记录相册的ID

  // PRD 要求的图片描述
  String? description;
}