import 'dart:async';
import 'dart:math';

import 'package:isar_sample/data/repositories/user_repository/provider.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

/// ホーム画面のViewModel
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  void build() {}

  /// ユーザー情報の作成と取得
  Future<List<User>> createAndFetchUser() async {
    final user = _createRandomUser();
    await ref.read(userRepositoryProvider).create(user);
    return fetchAllUsers();
  }

  /// ユーザー情報の取得
  Future<List<User>> fetchAllUsers() async =>
      ref.read(userRepositoryProvider).findAll();

  /// ユーザー情報の更新と取得
  ///
  /// 更新内容はidとname以外の項目をランダムに更新する
  Future<List<User>> updateAndFetchUser(User user) async {
    final randomUser = _createRandomUser();
    final updatedUser = user.copyWith(
      id: user.id,
      name: user.name,
      age: randomUser.age,
      isDrinkingAlcohol: randomUser.isDrinkingAlcohol,
      homeTown: randomUser.homeTown,
    );
    await ref.read(userRepositoryProvider).update(updatedUser);
    return fetchAllUsers();
  }

  /// ユーザー情報の削除と取得
  Future<List<User>> deleteAndFetchUser(User user) async {
    final userId = user.id;
    if (userId == null) return fetchAllUsers();
    await ref.read(userRepositoryProvider).delete(userId);
    return fetchAllUsers();
  }

  /// ユーザー情報の初期化
  Future<List<User>> initUser() async {
    await ref.read(userRepositoryProvider).deleteAll();
    return [];
  }

  /// ランダムなユーザー情報の生成
  User _createRandomUser() {
    // 乱数生成のためのインスタンス
    final random = Random();
    // ランダムな名前の生成 (アルファベットをランダムに結合)
    final name =
        String.fromCharCodes(List.generate(5, (_) => random.nextInt(26) + 65));
    // ランダムな年齢 (18から60歳の範囲で生成)
    final age = random.nextInt(43) + 18;
    // ランダムな飲酒フラグ
    final isDrinkingAlcohol = random.nextBool();
    // ランダムな出身地
    const homeTownValues = HomeTown.values;
    final homeTown = homeTownValues[random.nextInt(homeTownValues.length)];
    // ランダムユーザーの作成
    return User(
      name: name,
      age: age,
      isDrinkingAlcohol: isDrinkingAlcohol,
      homeTown: homeTown,
    );
  }
}
