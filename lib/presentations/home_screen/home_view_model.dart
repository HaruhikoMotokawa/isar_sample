import 'dart:async';

import 'package:isar_sample/data/repositories/user_repository/provider.dart';
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
    final user = User.random();
    await ref.read(userRepositoryProvider).save(user);
    return fetchAllUsers();
  }

  /// ユーザー情報の取得
  Future<List<User>> fetchAllUsers() async =>
      ref.read(userRepositoryProvider).findAll();

  /// ユーザー情報の更新と取得
  ///
  /// 更新内容はidとname以外の項目をランダムに更新する
  Future<List<User>> updateAndFetchUser(User user) async {
    final updatedUser = user.createUpdatedUser();
    await ref.read(userRepositoryProvider).save(updatedUser);
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
}
