// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImageModelCollection on Isar {
  IsarCollection<ImageModel> get imageModels => this.collection();
}

const ImageModelSchema = CollectionSchema(
  name: r'ImageModel',
  id: -4998388787585861710,
  properties: {
    r'addedTime': PropertySchema(
      id: 0,
      name: r'addedTime',
      type: IsarType.dateTime,
    ),
    r'albumIds': PropertySchema(
      id: 1,
      name: r'albumIds',
      type: IsarType.longList,
    ),
    r'createdTime': PropertySchema(
      id: 2,
      name: r'createdTime',
      type: IsarType.dateTime,
    ),
    r'deletedTime': PropertySchema(
      id: 3,
      name: r'deletedTime',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'extension': PropertySchema(
      id: 5,
      name: r'extension',
      type: IsarType.string,
    ),
    r'filename': PropertySchema(
      id: 6,
      name: r'filename',
      type: IsarType.string,
    ),
    r'height': PropertySchema(
      id: 7,
      name: r'height',
      type: IsarType.long,
    ),
    r'modifiedTime': PropertySchema(
      id: 8,
      name: r'modifiedTime',
      type: IsarType.dateTime,
    ),
    r'originalFilename': PropertySchema(
      id: 9,
      name: r'originalFilename',
      type: IsarType.string,
    ),
    r'originalPath': PropertySchema(
      id: 10,
      name: r'originalPath',
      type: IsarType.string,
    ),
    r'path': PropertySchema(
      id: 11,
      name: r'path',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 12,
      name: r'rating',
      type: IsarType.byte,
    ),
    r'sizeBytes': PropertySchema(
      id: 13,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'sourceApp': PropertySchema(
      id: 14,
      name: r'sourceApp',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 15,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'width': PropertySchema(
      id: 16,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _imageModelEstimateSize,
  serialize: _imageModelSerialize,
  deserialize: _imageModelDeserialize,
  deserializeProp: _imageModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'path': IndexSchema(
      id: 8756705481922369689,
      name: r'path',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'path',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'extension': IndexSchema(
      id: 8733860368720318111,
      name: r'extension',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'extension',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'addedTime': IndexSchema(
      id: -5988071053170993094,
      name: r'addedTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'addedTime',
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
    r'rating': IndexSchema(
      id: 3934517271104932818,
      name: r'rating',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rating',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'tags': IndexSchema(
      id: 4029205728550669204,
      name: r'tags',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tags',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deletedTime': IndexSchema(
      id: -6683334201728748851,
      name: r'deletedTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deletedTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _imageModelGetId,
  getLinks: _imageModelGetLinks,
  attach: _imageModelAttach,
  version: '3.1.0+1',
);

int _imageModelEstimateSize(
  ImageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumIds.length * 8;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.extension.length * 3;
  bytesCount += 3 + object.filename.length * 3;
  {
    final value = object.originalFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.originalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.path.length * 3;
  {
    final value = object.sourceApp;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _imageModelSerialize(
  ImageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.addedTime);
  writer.writeLongList(offsets[1], object.albumIds);
  writer.writeDateTime(offsets[2], object.createdTime);
  writer.writeDateTime(offsets[3], object.deletedTime);
  writer.writeString(offsets[4], object.description);
  writer.writeString(offsets[5], object.extension);
  writer.writeString(offsets[6], object.filename);
  writer.writeLong(offsets[7], object.height);
  writer.writeDateTime(offsets[8], object.modifiedTime);
  writer.writeString(offsets[9], object.originalFilename);
  writer.writeString(offsets[10], object.originalPath);
  writer.writeString(offsets[11], object.path);
  writer.writeByte(offsets[12], object.rating);
  writer.writeLong(offsets[13], object.sizeBytes);
  writer.writeString(offsets[14], object.sourceApp);
  writer.writeStringList(offsets[15], object.tags);
  writer.writeLong(offsets[16], object.width);
}

ImageModel _imageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImageModel();
  object.addedTime = reader.readDateTime(offsets[0]);
  object.albumIds = reader.readLongList(offsets[1]) ?? [];
  object.createdTime = reader.readDateTime(offsets[2]);
  object.deletedTime = reader.readDateTimeOrNull(offsets[3]);
  object.description = reader.readStringOrNull(offsets[4]);
  object.extension = reader.readString(offsets[5]);
  object.filename = reader.readString(offsets[6]);
  object.height = reader.readLong(offsets[7]);
  object.id = id;
  object.modifiedTime = reader.readDateTime(offsets[8]);
  object.originalFilename = reader.readStringOrNull(offsets[9]);
  object.originalPath = reader.readStringOrNull(offsets[10]);
  object.path = reader.readString(offsets[11]);
  object.rating = reader.readByte(offsets[12]);
  object.sizeBytes = reader.readLong(offsets[13]);
  object.sourceApp = reader.readStringOrNull(offsets[14]);
  object.tags = reader.readStringList(offsets[15]) ?? [];
  object.width = reader.readLong(offsets[16]);
  return object;
}

P _imageModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readByte(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringList(offset) ?? []) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _imageModelGetId(ImageModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _imageModelGetLinks(ImageModel object) {
  return [];
}

void _imageModelAttach(IsarCollection<dynamic> col, Id id, ImageModel object) {
  object.id = id;
}

extension ImageModelQueryWhereSort
    on QueryBuilder<ImageModel, ImageModel, QWhere> {
  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyAddedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'addedTime'),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdTime'),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'modifiedTime'),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'rating'),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhere> anyDeletedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deletedTime'),
      );
    });
  }
}

extension ImageModelQueryWhere
    on QueryBuilder<ImageModel, ImageModel, QWhereClause> {
  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> pathEqualTo(
      String path) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'path',
        value: [path],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> pathNotEqualTo(
      String path) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> extensionEqualTo(
      String extension) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'extension',
        value: [extension],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> extensionNotEqualTo(
      String extension) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'extension',
              lower: [],
              upper: [extension],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'extension',
              lower: [extension],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'extension',
              lower: [extension],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'extension',
              lower: [],
              upper: [extension],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> addedTimeEqualTo(
      DateTime addedTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'addedTime',
        value: [addedTime],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> addedTimeNotEqualTo(
      DateTime addedTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedTime',
              lower: [],
              upper: [addedTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedTime',
              lower: [addedTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedTime',
              lower: [addedTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedTime',
              lower: [],
              upper: [addedTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> addedTimeGreaterThan(
    DateTime addedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedTime',
        lower: [addedTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> addedTimeLessThan(
    DateTime addedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedTime',
        lower: [],
        upper: [addedTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> addedTimeBetween(
    DateTime lowerAddedTime,
    DateTime upperAddedTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedTime',
        lower: [lowerAddedTime],
        includeLower: includeLower,
        upper: [upperAddedTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> createdTimeEqualTo(
      DateTime createdTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdTime',
        value: [createdTime],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> createdTimeNotEqualTo(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause>
      createdTimeGreaterThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> createdTimeLessThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> createdTimeBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> modifiedTimeEqualTo(
      DateTime modifiedTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modifiedTime',
        value: [modifiedTime],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause>
      modifiedTimeNotEqualTo(DateTime modifiedTime) {
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause>
      modifiedTimeGreaterThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> modifiedTimeLessThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> modifiedTimeBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> ratingEqualTo(
      int rating) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rating',
        value: [rating],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> ratingNotEqualTo(
      int rating) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rating',
              lower: [],
              upper: [rating],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rating',
              lower: [rating],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rating',
              lower: [rating],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rating',
              lower: [],
              upper: [rating],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> ratingGreaterThan(
    int rating, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rating',
        lower: [rating],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> ratingLessThan(
    int rating, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rating',
        lower: [],
        upper: [rating],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> ratingBetween(
    int lowerRating,
    int upperRating, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rating',
        lower: [lowerRating],
        includeLower: includeLower,
        upper: [upperRating],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> tagsEqualTo(
      List<String> tags) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tags',
        value: [tags],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> tagsNotEqualTo(
      List<String> tags) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tags',
              lower: [],
              upper: [tags],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tags',
              lower: [tags],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tags',
              lower: [tags],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tags',
              lower: [],
              upper: [tags],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> deletedTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deletedTime',
        value: [null],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause>
      deletedTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedTime',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> deletedTimeEqualTo(
      DateTime? deletedTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deletedTime',
        value: [deletedTime],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> deletedTimeNotEqualTo(
      DateTime? deletedTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedTime',
              lower: [],
              upper: [deletedTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedTime',
              lower: [deletedTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedTime',
              lower: [deletedTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedTime',
              lower: [],
              upper: [deletedTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause>
      deletedTimeGreaterThan(
    DateTime? deletedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedTime',
        lower: [deletedTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> deletedTimeLessThan(
    DateTime? deletedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedTime',
        lower: [],
        upper: [deletedTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterWhereClause> deletedTimeBetween(
    DateTime? lowerDeletedTime,
    DateTime? upperDeletedTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedTime',
        lower: [lowerDeletedTime],
        includeLower: includeLower,
        upper: [upperDeletedTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageModelQueryFilter
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {
  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> addedTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      addedTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> addedTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> addedTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      albumIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albumIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      createdTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      createdTimeLessThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      createdTimeBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedTime',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedTime',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      deletedTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      extensionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extension',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      extensionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> extensionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extension',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      extensionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      extensionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      filenameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      filenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> filenameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      filenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filename',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      filenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filename',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> heightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> heightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> heightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      modifiedTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      modifiedTimeLessThan(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      modifiedTimeBetween(
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

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalFilename',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalFilename',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalPath',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalPath',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      originalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> ratingEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> ratingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> ratingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> ratingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sizeBytesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceApp',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceApp',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceApp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceApp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> sourceAppMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceApp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceApp',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      sourceAppIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceApp',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> tagsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition>
      tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> widthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> widthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> widthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterFilterCondition> widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImageModelQueryObject
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {}

extension ImageModelQueryLinks
    on QueryBuilder<ImageModel, ImageModel, QFilterCondition> {}

extension ImageModelQuerySortBy
    on QueryBuilder<ImageModel, ImageModel, QSortBy> {
  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByAddedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByAddedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByCreatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByDeletedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByDeletedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filename', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filename', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByOriginalFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFilename', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy>
      sortByOriginalFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFilename', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortBySourceApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceApp', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortBySourceAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceApp', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension ImageModelQuerySortThenBy
    on QueryBuilder<ImageModel, ImageModel, QSortThenBy> {
  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByAddedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByAddedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByCreatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByDeletedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByDeletedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filename', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filename', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByOriginalFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFilename', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy>
      thenByOriginalFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalFilename', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByOriginalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByOriginalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPath', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenBySourceApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceApp', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenBySourceAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceApp', Sort.desc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension ImageModelQueryWhereDistinct
    on QueryBuilder<ImageModel, ImageModel, QDistinct> {
  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByAddedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedTime');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByAlbumIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumIds');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByCreatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdTime');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByDeletedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedTime');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByExtension(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extension', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filename', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedTime');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByOriginalFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByOriginalPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctBySourceApp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceApp', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<ImageModel, ImageModel, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension ImageModelQueryProperty
    on QueryBuilder<ImageModel, ImageModel, QQueryProperty> {
  QueryBuilder<ImageModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ImageModel, DateTime, QQueryOperations> addedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedTime');
    });
  }

  QueryBuilder<ImageModel, List<int>, QQueryOperations> albumIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumIds');
    });
  }

  QueryBuilder<ImageModel, DateTime, QQueryOperations> createdTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdTime');
    });
  }

  QueryBuilder<ImageModel, DateTime?, QQueryOperations> deletedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedTime');
    });
  }

  QueryBuilder<ImageModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ImageModel, String, QQueryOperations> extensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extension');
    });
  }

  QueryBuilder<ImageModel, String, QQueryOperations> filenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filename');
    });
  }

  QueryBuilder<ImageModel, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<ImageModel, DateTime, QQueryOperations> modifiedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedTime');
    });
  }

  QueryBuilder<ImageModel, String?, QQueryOperations>
      originalFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalFilename');
    });
  }

  QueryBuilder<ImageModel, String?, QQueryOperations> originalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPath');
    });
  }

  QueryBuilder<ImageModel, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<ImageModel, int, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<ImageModel, int, QQueryOperations> sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }

  QueryBuilder<ImageModel, String?, QQueryOperations> sourceAppProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceApp');
    });
  }

  QueryBuilder<ImageModel, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<ImageModel, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
