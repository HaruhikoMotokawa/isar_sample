import 'package:isar/isar.dart';
import 'package:isar_sample/core/log/logger.dart';
import 'package:isar_sample/data/local_sources/isar.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:isar_sample/domains/filter_type.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/pet.dart';
import 'package:isar_sample/domains/sort_type.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class UserRepositoryBase {
  /// 全てのUser情報を検索する
  Future<List<User>> findAll({
    SortType? sortType,
    List<FilterType>? filters,
  });

  /// Userを保存する
  Future<void> save(User user);

  /// Userを削除する
  Future<void> delete(int userId);

  /// 全てのUserを削除する
  Future<void> deleteAll();

  /// 複数のUserを保存する
  ///
  /// オプションで同期出来るようにする
  Future<void> saveBatch(List<User> users, {bool sync = false});

  /// 複数のUserを削除する
  ///
  /// オプションで同期出来るようにする
  Future<void> deleteBatch(List<int> userIds, {bool sync = false});

  // Userコレクションを監視する
  Stream<List<User>> watch({
    required SortType sortType,
    List<FilterType>? filters,
  });
}

class UserRepository implements UserRepositoryBase {
  UserRepository(this.ref);

  final ProviderRef<dynamic> ref;

  @override
  Future<void> save(User user) async {
    final isar = await ref.read(isarProvider.future);
    final userEntity = user.toEntity();
    await isar.writeTxn(() async {
      await isar.userEntitys.put(userEntity);
    });
  }

  @override
  Future<void> delete(int userId) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.userEntitys.delete(userId);
    });
  }

  @override
  Future<List<User>> findAll({
    SortType? sortType,
    List<FilterType>? filters,
  }) async {
    final isar = await ref.read(isarProvider.future);

    final entities = isar.userEntitys;

    final stopwatch = Stopwatch();
    if (filters == null || filters.isEmpty) {
      final queryWhere = entities.where();
      // ソートの種類によってクエリを変更
      final query = switch (sortType) {
        SortType.nameAsc => queryWhere.sortByName(),
        SortType.nameDesc => queryWhere.sortByNameDesc(),
        SortType.ageAsc => queryWhere.sortByAge(),
        SortType.ageDesc => queryWhere.sortByAgeDesc(),
        SortType.hometown => queryWhere.sortByHomeTown(),
        SortType.dragonBallCharacter => queryWhere.sortByDragonBallCharacter(),
        _ => queryWhere,
      };
      // ストップウォッチ開始
      stopwatch.start();
      final userEntitys = await query.findAll();
      stopwatch.stop(); // ストップウォッチ終了
      logger.d(
        'findAll: ${stopwatch.elapsedMilliseconds}ms, sortType: $sortType',
      );
      return userEntitys.map((entity) => entity.toDomain()).toList();
    }

    var filterConditions = entities.filter();

    final ageFilters = filters.filterByAgeCategory;
    final originFilters = filters.filterByOrigin;
    final petFilters = filters.filterByPet;

    if (ageFilters.isNotEmpty) {
      filterConditions =
          filterConditions.anyOf<FilterType, Object>(ageFilters, (query, type) {
        return switch (type) {
          FilterType.young => query.ageBetween(18, 29),
          FilterType.middleAged => query.ageBetween(30, 50),
          FilterType.elderly => query.ageGreaterThan(50),
          _ => throw UnimplementedError(),
        };
      });
    }

    if (originFilters.isNotEmpty) {
      filterConditions = filterConditions
          .anyOf<FilterType, Object>(originFilters, (query, type) {
        return switch (type) {
          FilterType.originSapporo => query.homeTownEqualTo(HomeTown.Sapporo),
          FilterType.originSendai => query.homeTownEqualTo(HomeTown.Sendai),
          FilterType.originTokyo => query.homeTownEqualTo(HomeTown.Tokyo),
          FilterType.originOsaka => query.homeTownEqualTo(HomeTown.Osaka),
          FilterType.originKyoto => query.homeTownEqualTo(HomeTown.Kyoto),
          FilterType.originFukuoka => query.homeTownEqualTo(HomeTown.Fukuoka),
          _ => throw UnimplementedError(),
        };
      });
    }

    if (petFilters.isNotEmpty) {
      filterConditions =
          filterConditions.anyOf<FilterType, Object>(petFilters, (query, type) {
        return switch (type) {
          FilterType.ownsDog => query.petsElementContains(Pet.dog.name),
          FilterType.ownsCat => query.petsElementContains(Pet.cat.name),
          FilterType.ownsRabbit => query.petsElementContains(Pet.rabbit.name),
          FilterType.ownsParrot => query.petsElementContains(Pet.parrot.name),
          FilterType.ownsHamster => query.petsElementContains(Pet.hamster.name),
          _ => throw UnimplementedError(),
        };
      });
    }

    final query = filterConditions
        as QueryBuilder<UserEntity, UserEntity, QAfterFilterCondition>;

    final sortedQuery = switch (sortType) {
      SortType.nameAsc => query.sortByName(),
      SortType.nameDesc => query.sortByNameDesc(),
      SortType.ageAsc => query.sortByAge(),
      SortType.ageDesc => query.sortByAgeDesc(),
      SortType.hometown => query.sortByHomeTown(),
      SortType.dragonBallCharacter => query.sortByDragonBallCharacter(),
      _ => throw UnimplementedError(),
    };

    // ストップウォッチ開始
    stopwatch.start();
    final userEntitys = await sortedQuery.findAll();
    stopwatch.stop(); // ストップウォッチ終了
    logger
        .d('findAll: ${stopwatch.elapsedMilliseconds}ms, sortType: $sortType');
    return userEntitys.map((entity) => entity.toDomain()).toList();
  }

  @override
  Future<void> deleteAll() async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.userEntitys.clear();
    });
  }

  @override
  Future<void> saveBatch(List<User> users, {bool sync = false}) async {
    final isar = await ref.read(isarProvider.future);
    final userEntities = users.map((user) => user.toEntity()).toList();
    if (sync) {
      isar.writeTxnSync(() {
        isar.userEntitys.putAllSync(userEntities);
      });
    } else {
      await isar.writeTxn(() async {
        await isar.userEntitys.putAll(userEntities);
      });
    }
  }

  @override
  Future<void> deleteBatch(List<int> userIds, {bool sync = false}) async {
    final isar = await ref.read(isarProvider.future);
    if (sync) {
      isar.writeTxnSync(() {
        isar.userEntitys.deleteAllSync(userIds);
      });
    } else {
      await isar.writeTxn(() async {
        await isar.userEntitys.deleteAll(userIds);
      });
    }
  }

  @override
  Stream<List<User>> watch({
    required SortType sortType,
    List<FilterType>? filters,
  }) async* {
    final isar = await ref.read(isarProvider.future);
    // watchLazy で変更を監視
    final userStream = isar.userEntitys.watchLazy(fireImmediately: true);
    await for (final _ in userStream) {
      yield await findAll(
        sortType: sortType,
        filters: filters,
      );
    }
  }
}

extension UserEntityMapper on UserEntity {
  /// UserEntityからUserへの変換
  User toDomain() {
    return User(
      id: id,
      name: name,
      age: age,
      isDrinkingAlcohol: isDrinkingAlcohol,
      homeTown: homeTown,
      pets: pets,
      dragonBallCharacter: dragonBallCharacter,
      skill: skill != null
          ? Skill(
              name: skill!.name,
              description: skill!.description,
              yearsOfExperience: skill!.yearsOfExperience,
            )
          : null,
    );
  }
}

extension UserMapper on User {
  /// UserからUserEntityへの変換
  UserEntity toEntity() {
    return UserEntity()
      ..id = id ?? Isar.autoIncrement
      ..name = name
      ..age = age
      ..isDrinkingAlcohol = isDrinkingAlcohol
      ..homeTown = homeTown
      ..pets = pets
      ..dragonBallCharacter = dragonBallCharacter
      ..skill = skill != null
          ? Skill(
              name: skill!.name,
              description: skill!.description,
              yearsOfExperience: skill!.yearsOfExperience,
            )
          : null;
  }
}
