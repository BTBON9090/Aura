// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTagModelCollection on Isar {
  IsarCollection<TagModel> get tagModels => this.collection();
}

const TagModelSchema = CollectionSchema(
  name: r'TagModel',
  id: -5876547621865093726,
  properties: {
    r'createdTime': PropertySchema(
      id: 0,
      name: r'createdTime',
      type: IsarType.dateTime,
    ),
    r'groupId': PropertySchema(
      id: 1,
      name: r'groupId',
      type: IsarType.long,
    ),
    r'isFrequentlyUsed': PropertySchema(
      id: 2,
      name: r'isFrequentlyUsed',
      type: IsarType.bool,
    ),
    r'modifiedTime': PropertySchema(
      id: 3,
      name: r'modifiedTime',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _tagModelEstimateSize,
  serialize: _tagModelSerialize,
  deserialize: _tagModelDeserialize,
  deserializeProp: _tagModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isFrequentlyUsed': IndexSchema(
      id: 2994139700505074895,
      name: r'isFrequentlyUsed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isFrequentlyUsed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'modifiedTime': IndexSchema(
      id: -608962959549919354,
      name: r'modifiedTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'modifiedTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'createdTime': IndexSchema(
      id: 8163241038237961676,
      name: r'createdTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tagModelGetId,
  getLinks: _tagModelGetLinks,
  attach: _tagModelAttach,
  version: '3.1.0+1',
);

int _tagModelEstimateSize(
  TagModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _tagModelSerialize(
  TagModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdTime);
  writer.writeLong(offsets[1], object.groupId);
  writer.writeBool(offsets[2], object.isFrequentlyUsed);
  writer.writeDateTime(offsets[3], object.modifiedTime);
  writer.writeString(offsets[4], object.name);
}

TagModel _tagModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TagModel();
  object.createdTime = reader.readDateTime(offsets[0]);
  object.groupId = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.isFrequentlyUsed = reader.readBool(offsets[2]);
  object.modifiedTime = reader.readDateTime(offsets[3]);
  object.name = reader.readString(offsets[4]);
  return object;
}

P _tagModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tagModelGetId(TagModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tagModelGetLinks(TagModel object) {
  return [];
}

void _tagModelAttach(IsarCollection<dynamic> col, Id id, TagModel object) {
  object.id = id;
}

extension TagModelQueryWhereSort on QueryBuilder<TagModel, TagModel, QWhere> {
  QueryBuilder<TagModel, TagModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhere> anyGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'groupId'),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhere> anyIsFrequentlyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isFrequentlyUsed'),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhere> anyModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'modifiedTime'),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhere> anyCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdTime'),
      );
    });
  }
}

extension TagModelQueryWhere on QueryBuilder<TagModel, TagModel, QWhereClause> {
  QueryBuilder<TagModel, TagModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [name],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [],
        upper: [name],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [lowerName],
        includeLower: includeLower,
        upper: [upperName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [null],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdEqualTo(
      int? groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdNotEqualTo(
      int? groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdGreaterThan(
    int? groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [groupId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdLessThan(
    int? groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [],
        upper: [groupId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> groupIdBetween(
    int? lowerGroupId,
    int? upperGroupId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [lowerGroupId],
        includeLower: includeLower,
        upper: [upperGroupId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> isFrequentlyUsedEqualTo(
      bool isFrequentlyUsed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isFrequentlyUsed',
        value: [isFrequentlyUsed],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause>
      isFrequentlyUsedNotEqualTo(bool isFrequentlyUsed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isFrequentlyUsed',
              lower: [],
              upper: [isFrequentlyUsed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isFrequentlyUsed',
              lower: [isFrequentlyUsed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isFrequentlyUsed',
              lower: [isFrequentlyUsed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isFrequentlyUsed',
              lower: [],
              upper: [isFrequentlyUsed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> modifiedTimeEqualTo(
      DateTime modifiedTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modifiedTime',
        value: [modifiedTime],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> modifiedTimeNotEqualTo(
      DateTime modifiedTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [],
              upper: [modifiedTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [modifiedTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [modifiedTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [],
              upper: [modifiedTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> modifiedTimeGreaterThan(
    DateTime modifiedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [modifiedTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> modifiedTimeLessThan(
    DateTime modifiedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [],
        upper: [modifiedTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> modifiedTimeBetween(
    DateTime lowerModifiedTime,
    DateTime upperModifiedTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [lowerModifiedTime],
        includeLower: includeLower,
        upper: [upperModifiedTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> createdTimeEqualTo(
      DateTime createdTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdTime',
        value: [createdTime],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> createdTimeNotEqualTo(
      DateTime createdTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTime',
              lower: [],
              upper: [createdTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTime',
              lower: [createdTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTime',
              lower: [createdTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTime',
              lower: [],
              upper: [createdTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> createdTimeGreaterThan(
    DateTime createdTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTime',
        lower: [createdTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> createdTimeLessThan(
    DateTime createdTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTime',
        lower: [],
        upper: [createdTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterWhereClause> createdTimeBetween(
    DateTime lowerCreatedTime,
    DateTime upperCreatedTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTime',
        lower: [lowerCreatedTime],
        includeLower: includeLower,
        upper: [upperCreatedTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TagModelQueryFilter
    on QueryBuilder<TagModel, TagModel, QFilterCondition> {
  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> createdTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition>
      createdTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> createdTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> createdTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> groupIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition>
      isFrequentlyUsedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFrequentlyUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> modifiedTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition>
      modifiedTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> modifiedTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> modifiedTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifiedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension TagModelQueryObject
    on QueryBuilder<TagModel, TagModel, QFilterCondition> {}

extension TagModelQueryLinks
    on QueryBuilder<TagModel, TagModel, QFilterCondition> {}

extension TagModelQuerySortBy on QueryBuilder<TagModel, TagModel, QSortBy> {
  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByCreatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByIsFrequentlyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlyUsed', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByIsFrequentlyUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlyUsed', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension TagModelQuerySortThenBy
    on QueryBuilder<TagModel, TagModel, QSortThenBy> {
  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByCreatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByIsFrequentlyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlyUsed', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByIsFrequentlyUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFrequentlyUsed', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TagModel, TagModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension TagModelQueryWhereDistinct
    on QueryBuilder<TagModel, TagModel, QDistinct> {
  QueryBuilder<TagModel, TagModel, QDistinct> distinctByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdTime');
    });
  }

  QueryBuilder<TagModel, TagModel, QDistinct> distinctByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId');
    });
  }

  QueryBuilder<TagModel, TagModel, QDistinct> distinctByIsFrequentlyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFrequentlyUsed');
    });
  }

  QueryBuilder<TagModel, TagModel, QDistinct> distinctByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedTime');
    });
  }

  QueryBuilder<TagModel, TagModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension TagModelQueryProperty
    on QueryBuilder<TagModel, TagModel, QQueryProperty> {
  QueryBuilder<TagModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TagModel, DateTime, QQueryOperations> createdTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdTime');
    });
  }

  QueryBuilder<TagModel, int?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<TagModel, bool, QQueryOperations> isFrequentlyUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFrequentlyUsed');
    });
  }

  QueryBuilder<TagModel, DateTime, QQueryOperations> modifiedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedTime');
    });
  }

  QueryBuilder<TagModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
