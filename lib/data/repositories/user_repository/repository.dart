import 'package:isar/isar.dart';
import 'package:isar_sample/core/log/logger.dart';
import 'package:isar_sample/data/local_sources/isar.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:isar_sample/domains/sort_type.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class UserRepositoryBase {
  /// 全てのUser情報を検索する
  Future<List<User>> findAll({SortType? sortType});

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
  Stream<List<User>> watch({required SortType sortType});
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
  Future<List<User>> findAll({SortType? sortType}) async {
    final isar = await ref.read(isarProvider.future);

    // where()でクエリを作成
    final query = isar.userEntitys.where();

    // ソートの種類によってクエリを変更
    final sortQuery = switch (sortType) {
      SortType.nameAsc => query.sortByName(),
      SortType.nameDesc => query.sortByNameDesc(),
      SortType.ageAsc => query.sortByAge(),
      SortType.ageDesc => query.sortByAgeDesc(),
      SortType.hometown => query.sortByHomeTown(),
      SortType.dragonBallCharacter => query.sortByDragonBallCharacter(),
      _ => query,
    };
    final stopwatch = Stopwatch()..start(); // ストップウォッチ開始
    final userEntitys = await sortQuery.findAll();
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
  Stream<List<User>> watch({required SortType sortType}) async* {
    final isar = await ref.read(isarProvider.future);
    // watchLazy で変更を監視
    final userStream = isar.userEntitys.watchLazy(fireImmediately: true);
    await for (final _ in userStream) {
      yield await findAll(sortType: sortType);
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
