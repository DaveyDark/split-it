// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSplitCollection on Isar {
  IsarCollection<Split> get splits => this.collection();
}

const SplitSchema = CollectionSchema(
  name: r'Split',
  id: -746995213775774434,
  properties: {
    r'contributors': PropertySchema(
      id: 0,
      name: r'contributors',
      type: IsarType.stringList,
    ),
    r'created': PropertySchema(
      id: 1,
      name: r'created',
      type: IsarType.dateTime,
    ),
    r'settled': PropertySchema(
      id: 2,
      name: r'settled',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _splitEstimateSize,
  serialize: _splitSerialize,
  deserialize: _splitDeserialize,
  deserializeProp: _splitDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'transactions': LinkSchema(
      id: 4715599682942797684,
      name: r'transactions',
      target: r'Transaction',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _splitGetId,
  getLinks: _splitGetLinks,
  attach: _splitAttach,
  version: '3.1.0+1',
);

int _splitEstimateSize(
  Split object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contributors.length * 3;
  {
    for (var i = 0; i < object.contributors.length; i++) {
      final value = object.contributors[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _splitSerialize(
  Split object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.contributors);
  writer.writeDateTime(offsets[1], object.created);
  writer.writeBool(offsets[2], object.settled);
  writer.writeString(offsets[3], object.title);
}

Split _splitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Split();
  object.contributors = reader.readStringList(offsets[0]) ?? [];
  object.created = reader.readDateTime(offsets[1]);
  object.id = id;
  object.settled = reader.readBool(offsets[2]);
  object.title = reader.readString(offsets[3]);
  return object;
}

P _splitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _splitGetId(Split object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _splitGetLinks(Split object) {
  return [object.transactions];
}

void _splitAttach(IsarCollection<dynamic> col, Id id, Split object) {
  object.id = id;
  object.transactions
      .attach(col, col.isar.collection<Transaction>(), r'transactions', id);
}

extension SplitQueryWhereSort on QueryBuilder<Split, Split, QWhere> {
  QueryBuilder<Split, Split, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SplitQueryWhere on QueryBuilder<Split, Split, QWhereClause> {
  QueryBuilder<Split, Split, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Split, Split, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idBetween(
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

extension SplitQueryFilter on QueryBuilder<Split, Split, QFilterCondition> {
  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      contributorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contributors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      contributorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contributors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contributors',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      contributorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributors',
        value: '',
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      contributorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contributors',
        value: '',
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      contributorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> contributorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributors',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> createdEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> createdGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> createdLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> createdBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> settledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'settled',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension SplitQueryObject on QueryBuilder<Split, Split, QFilterCondition> {}

extension SplitQueryLinks on QueryBuilder<Split, Split, QFilterCondition> {
  QueryBuilder<Split, Split, QAfterFilterCondition> transactions(
      FilterQuery<Transaction> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'transactions');
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> transactionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', length, true, length, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> transactionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, true, 0, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> transactionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> transactionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', 0, true, length, include);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition>
      transactionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'transactions', length, include, 999999, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> transactionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'transactions', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SplitQuerySortBy on QueryBuilder<Split, Split, QSortBy> {
  QueryBuilder<Split, Split, QAfterSortBy> sortByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortBySettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settled', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortBySettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settled', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SplitQuerySortThenBy on QueryBuilder<Split, Split, QSortThenBy> {
  QueryBuilder<Split, Split, QAfterSortBy> thenByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenBySettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settled', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenBySettledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settled', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SplitQueryWhereDistinct on QueryBuilder<Split, Split, QDistinct> {
  QueryBuilder<Split, Split, QDistinct> distinctByContributors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contributors');
    });
  }

  QueryBuilder<Split, Split, QDistinct> distinctByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created');
    });
  }

  QueryBuilder<Split, Split, QDistinct> distinctBySettled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'settled');
    });
  }

  QueryBuilder<Split, Split, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension SplitQueryProperty on QueryBuilder<Split, Split, QQueryProperty> {
  QueryBuilder<Split, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Split, List<String>, QQueryOperations> contributorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contributors');
    });
  }

  QueryBuilder<Split, DateTime, QQueryOperations> createdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created');
    });
  }

  QueryBuilder<Split, bool, QQueryOperations> settledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'settled');
    });
  }

  QueryBuilder<Split, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
