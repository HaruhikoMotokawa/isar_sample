import 'package:isar/isar.dart';
import 'package:isar_sample/data/local_sources/isar.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class UserRepositoryBase {
  /// 全てのUser情報を検索する
  Future<List<User>> findAll();

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
  Future<List<User>> findAll() async {
    final isar = await ref.read(isarProvider.future);
    final userEntitys = await isar.userEntitys.where().findAll();
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
