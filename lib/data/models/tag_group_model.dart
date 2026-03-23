import 'package:isar/isar.dart';

part 'tag_group_model.g.dart';

@collection
class TagGroupModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index()
  late DateTime createdTime;
}