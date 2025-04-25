// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAudioCollection on Isar {
  IsarCollection<Audio> get audios => this.collection();
}

const AudioSchema = CollectionSchema(
  name: r'Audio',
  id: -3747845864647289041,
  properties: {
    r'currentMusic': PropertySchema(
      id: 0,
      name: r'currentMusic',
      type: IsarType.string,
    ),
    r'isMusicOn': PropertySchema(
      id: 1,
      name: r'isMusicOn',
      type: IsarType.bool,
    ),
    r'whiteNoise': PropertySchema(
      id: 2,
      name: r'whiteNoise',
      type: IsarType.stringList,
    )
  },
  estimateSize: _audioEstimateSize,
  serialize: _audioSerialize,
  deserialize: _audioDeserialize,
  deserializeProp: _audioDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _audioGetId,
  getLinks: _audioGetLinks,
  attach: _audioAttach,
  version: '3.1.0+1',
);

int _audioEstimateSize(
  Audio object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currentMusic.length * 3;
  bytesCount += 3 + object.whiteNoise.length * 3;
  {
    for (var i = 0; i < object.whiteNoise.length; i++) {
      final value = object.whiteNoise[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _audioSerialize(
  Audio object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currentMusic);
  writer.writeBool(offsets[1], object.isMusicOn);
  writer.writeStringList(offsets[2], object.whiteNoise);
}

Audio _audioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Audio(
    currentMusic: reader.readString(offsets[0]),
    isMusicOn: reader.readBool(offsets[1]),
    whiteNoise: reader.readStringList(offsets[2]) ?? [],
  );
  object.id = id;
  return object;
}

P _audioDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _audioGetId(Audio object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _audioGetLinks(Audio object) {
  return [];
}

void _audioAttach(IsarCollection<dynamic> col, Id id, Audio object) {
  object.id = id;
}

extension AudioQueryWhereSort on QueryBuilder<Audio, Audio, QWhere> {
  QueryBuilder<Audio, Audio, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AudioQueryWhere on QueryBuilder<Audio, Audio, QWhereClause> {
  QueryBuilder<Audio, Audio, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Audio, Audio, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterWhereClause> idBetween(
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

extension AudioQueryFilter on QueryBuilder<Audio, Audio, QFilterCondition> {
  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentMusic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentMusic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentMusic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMusic',
        value: '',
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> currentMusicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentMusic',
        value: '',
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Audio, Audio, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Audio, Audio, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Audio, Audio, QAfterFilterCondition> isMusicOnEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMusicOn',
        value: value,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition>
      whiteNoiseElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteNoise',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'whiteNoise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'whiteNoise',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteNoise',
        value: '',
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition>
      whiteNoiseElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'whiteNoise',
        value: '',
      ));
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Audio, Audio, QAfterFilterCondition> whiteNoiseLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'whiteNoise',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AudioQueryObject on QueryBuilder<Audio, Audio, QFilterCondition> {}

extension AudioQueryLinks on QueryBuilder<Audio, Audio, QFilterCondition> {}

extension AudioQuerySortBy on QueryBuilder<Audio, Audio, QSortBy> {
  QueryBuilder<Audio, Audio, QAfterSortBy> sortByCurrentMusic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMusic', Sort.asc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> sortByCurrentMusicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMusic', Sort.desc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> sortByIsMusicOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMusicOn', Sort.asc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> sortByIsMusicOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMusicOn', Sort.desc);
    });
  }
}

extension AudioQuerySortThenBy on QueryBuilder<Audio, Audio, QSortThenBy> {
  QueryBuilder<Audio, Audio, QAfterSortBy> thenByCurrentMusic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMusic', Sort.asc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> thenByCurrentMusicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMusic', Sort.desc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> thenByIsMusicOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMusicOn', Sort.asc);
    });
  }

  QueryBuilder<Audio, Audio, QAfterSortBy> thenByIsMusicOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMusicOn', Sort.desc);
    });
  }
}

extension AudioQueryWhereDistinct on QueryBuilder<Audio, Audio, QDistinct> {
  QueryBuilder<Audio, Audio, QDistinct> distinctByCurrentMusic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMusic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Audio, Audio, QDistinct> distinctByIsMusicOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMusicOn');
    });
  }

  QueryBuilder<Audio, Audio, QDistinct> distinctByWhiteNoise() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteNoise');
    });
  }
}

extension AudioQueryProperty on QueryBuilder<Audio, Audio, QQueryProperty> {
  QueryBuilder<Audio, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Audio, String, QQueryOperations> currentMusicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMusic');
    });
  }

  QueryBuilder<Audio, bool, QQueryOperations> isMusicOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMusicOn');
    });
  }

  QueryBuilder<Audio, List<String>, QQueryOperations> whiteNoiseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteNoise');
    });
  }
}
