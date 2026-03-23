import 'package:isar/isar.dart';

part 'tag_model.g.dart';

@collection
class TagModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index()
  int? groupId;

  @Index()
  bool isFrequentlyUsed = false;

  @Index()
  late DateTime modifiedTime;

  @Index()
  late DateTime createdTime;
}