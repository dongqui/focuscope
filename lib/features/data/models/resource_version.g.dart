// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_version.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetResourceVersionCollection on Isar {
  IsarCollection<ResourceVersion> get resourceVersions => this.collection();
}

const ResourceVersionSchema = CollectionSchema(
  name: r'ResourceVersion',
  id: -8600458410099647020,
  properties: {
    r'checkedAt': PropertySchema(
      id: 0,
      name: r'checkedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 1,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _resourceVersionEstimateSize,
  serialize: _resourceVersionSerialize,
  deserialize: _resourceVersionDeserialize,
  deserializeProp: _resourceVersionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _resourceVersionGetId,
  getLinks: _resourceVersionGetLinks,
  attach: _resourceVersionAttach,
  version: '3.1.0+1',
);

int _resourceVersionEstimateSize(
  ResourceVersion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _resourceVersionSerialize(
  ResourceVersion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.checkedAt);
  writer.writeLong(offsets[1], object.version);
}

ResourceVersion _resourceVersionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResourceVersion(
    checkedAt: reader.readDateTime(offsets[0]),
    version: reader.readLong(offsets[1]),
  );
  object.id = id;
  return object;
}

P _resourceVersionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _resourceVersionGetId(ResourceVersion object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _resourceVersionGetLinks(ResourceVersion object) {
  return [];
}

void _resourceVersionAttach(
    IsarCollection<dynamic> col, Id id, ResourceVersion object) {
  object.id = id;
}

extension ResourceVersionQueryWhereSort
    on QueryBuilder<ResourceVersion, ResourceVersion, QWhere> {
  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ResourceVersionQueryWhere
    on QueryBuilder<ResourceVersion, ResourceVersion, QWhereClause> {
  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterWhereClause> idBetween(
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
}

extension ResourceVersionQueryFilter
    on QueryBuilder<ResourceVersion, ResourceVersion, QFilterCondition> {
  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      checkedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      checkedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      checkedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      checkedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ResourceVersionQueryObject
    on QueryBuilder<ResourceVersion, ResourceVersion, QFilterCondition> {}

extension ResourceVersionQueryLinks
    on QueryBuilder<ResourceVersion, ResourceVersion, QFilterCondition> {}

extension ResourceVersionQuerySortBy
    on QueryBuilder<ResourceVersion, ResourceVersion, QSortBy> {
  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      sortByCheckedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedAt', Sort.asc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      sortByCheckedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedAt', Sort.desc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension ResourceVersionQuerySortThenBy
    on QueryBuilder<ResourceVersion, ResourceVersion, QSortThenBy> {
  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      thenByCheckedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedAt', Sort.asc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      thenByCheckedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkedAt', Sort.desc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension ResourceVersionQueryWhereDistinct
    on QueryBuilder<ResourceVersion, ResourceVersion, QDistinct> {
  QueryBuilder<ResourceVersion, ResourceVersion, QDistinct>
      distinctByCheckedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkedAt');
    });
  }

  QueryBuilder<ResourceVersion, ResourceVersion, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension ResourceVersionQueryProperty
    on QueryBuilder<ResourceVersion, ResourceVersion, QQueryProperty> {
  QueryBuilder<ResourceVersion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ResourceVersion, DateTime, QQueryOperations>
      checkedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkedAt');
    });
  }

  QueryBuilder<ResourceVersion, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
