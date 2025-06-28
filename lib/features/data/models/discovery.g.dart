// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiscoveryCollection on Isar {
  IsarCollection<Discovery> get discoverys => this.collection();
}

const DiscoverySchema = CollectionSchema(
  name: r'Discovery',
  id: 2359840210807683209,
  properties: {
    r'isFinished': PropertySchema(
      id: 0,
      name: r'isFinished',
      type: IsarType.bool,
    ),
    r'planetId': PropertySchema(
      id: 1,
      name: r'planetId',
      type: IsarType.long,
    ),
    r'sessionIds': PropertySchema(
      id: 2,
      name: r'sessionIds',
      type: IsarType.longList,
    )
  },
  estimateSize: _discoveryEstimateSize,
  serialize: _discoverySerialize,
  deserialize: _discoveryDeserialize,
  deserializeProp: _discoveryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _discoveryGetId,
  getLinks: _discoveryGetLinks,
  attach: _discoveryAttach,
  version: '3.1.0+1',
);

int _discoveryEstimateSize(
  Discovery object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sessionIds.length * 8;
  return bytesCount;
}

void _discoverySerialize(
  Discovery object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isFinished);
  writer.writeLong(offsets[1], object.planetId);
  writer.writeLongList(offsets[2], object.sessionIds);
}

Discovery _discoveryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Discovery(
    id: id,
    isFinished: reader.readBool(offsets[0]),
    planetId: reader.readLong(offsets[1]),
    sessionIds: reader.readLongList(offsets[2]) ?? [],
  );
  return object;
}

P _discoveryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _discoveryGetId(Discovery object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _discoveryGetLinks(Discovery object) {
  return [];
}

void _discoveryAttach(IsarCollection<dynamic> col, Id id, Discovery object) {
  object.id = id;
}

extension DiscoveryQueryWhereSort
    on QueryBuilder<Discovery, Discovery, QWhere> {
  QueryBuilder<Discovery, Discovery, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiscoveryQueryWhere
    on QueryBuilder<Discovery, Discovery, QWhereClause> {
  QueryBuilder<Discovery, Discovery, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Discovery, Discovery, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterWhereClause> idBetween(
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

extension DiscoveryQueryFilter
    on QueryBuilder<Discovery, Discovery, QFilterCondition> {
  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> isFinishedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> planetIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> planetIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> planetIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planetId',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition> planetIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterFilterCondition>
      sessionIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessionIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DiscoveryQueryObject
    on QueryBuilder<Discovery, Discovery, QFilterCondition> {}

extension DiscoveryQueryLinks
    on QueryBuilder<Discovery, Discovery, QFilterCondition> {}

extension DiscoveryQuerySortBy on QueryBuilder<Discovery, Discovery, QSortBy> {
  QueryBuilder<Discovery, Discovery, QAfterSortBy> sortByIsFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinished', Sort.asc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> sortByIsFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinished', Sort.desc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> sortByPlanetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetId', Sort.asc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> sortByPlanetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetId', Sort.desc);
    });
  }
}

extension DiscoveryQuerySortThenBy
    on QueryBuilder<Discovery, Discovery, QSortThenBy> {
  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenByIsFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinished', Sort.asc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenByIsFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinished', Sort.desc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenByPlanetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetId', Sort.asc);
    });
  }

  QueryBuilder<Discovery, Discovery, QAfterSortBy> thenByPlanetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetId', Sort.desc);
    });
  }
}

extension DiscoveryQueryWhereDistinct
    on QueryBuilder<Discovery, Discovery, QDistinct> {
  QueryBuilder<Discovery, Discovery, QDistinct> distinctByIsFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFinished');
    });
  }

  QueryBuilder<Discovery, Discovery, QDistinct> distinctByPlanetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planetId');
    });
  }

  QueryBuilder<Discovery, Discovery, QDistinct> distinctBySessionIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionIds');
    });
  }
}

extension DiscoveryQueryProperty
    on QueryBuilder<Discovery, Discovery, QQueryProperty> {
  QueryBuilder<Discovery, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Discovery, bool, QQueryOperations> isFinishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFinished');
    });
  }

  QueryBuilder<Discovery, int, QQueryOperations> planetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planetId');
    });
  }

  QueryBuilder<Discovery, List<int>, QQueryOperations> sessionIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionIds');
    });
  }
}
