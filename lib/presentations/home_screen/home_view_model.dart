import 'dart:async';

import 'package:isar_sample/core/log/logger.dart';
import 'package:isar_sample/data/repositories/user_repository/provider.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

/// ホーム画面のViewModel
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  void build() {}
  final _stopwatch = Stopwatch();

  /// ユーザー情報の作成と取得
  Future<void> create() async {
    final user = User.random();
    _stopwatch.start();
    await ref.read(userRepositoryProvider).save(user);
    _stopwatch.stop();
    logger.i('save: ${_stopwatch.elapsedMilliseconds}ms');
  }

  /// ユーザー情報の更新と取得
  ///
  /// 更新内容はidとname以外の項目をランダムに更新する
  Future<void> update(User user) async {
    final updatedUser = user.createUpdatedUser();
    _stopwatch.start();
    await ref.read(userRepositoryProvider).save(updatedUser);
    _stopwatch.stop();
    logger.i('save: ${_stopwatch.elapsedMilliseconds}ms');
  }

  /// ユーザー情報の削除と取得
  Future<void> delete(User user) async {
    final userId = user.id;
    if (userId == null) return;
    _stopwatch.start();
    await ref.read(userRepositoryProvider).delete(userId);
    _stopwatch.stop();
    logger.i('delete: ${_stopwatch.elapsedMilliseconds}ms');
  }

  /// ユーザー情報の初期化
  Future<void> initUser() async {
    _stopwatch.start();
    await ref.read(userRepositoryProvider).deleteAll();
    _stopwatch.stop();
    logger.i('deleteAll: ${_stopwatch.elapsedMilliseconds}ms');
  }

  /// 複数のユーザー情報を作成して取得する
  ///
  /// 引数に同期処理で実行するか非同期処理で実行するか選択できる
  Future<void> createBatch({
    required bool useSync,
    required int number,
  }) async {
    final users = List.generate(number, (_) => User.random());
    _stopwatch.start();
    await ref.read(userRepositoryProvider).saveBatch(users, sync: useSync);
    _stopwatch.stop();
    logger.i('saveBatch/sync $useSync : ${_stopwatch.elapsedMilliseconds}ms');
  }

  /// ユーザーをランダムで３つ削除する
  ///
  /// 引数で受け取ったユーザー情報リストの中からランダムで３つのユーザーを削除する
  /// 引数に同期処理で実行するか非同期処理で実行するか選択できる
  Future<void> deleteBatch({
    required List<User> users,
    required bool useSync,
    required int number,
  }) async {
    final userIds = users
        .map((user) => user.id)
        .where((id) => id != null)
        .take(number)
        .map((id) => id!)
        .toList();
    _stopwatch.start();
    await ref.read(userRepositoryProvider).deleteBatch(userIds, sync: useSync);
    _stopwatch.stop();
    logger.i('deleteBatch/sync $useSync: ${_stopwatch.elapsedMilliseconds}ms');
  }
}
