import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_sample/core/log/logger.dart';
import 'package:isar_sample/data/repositories/user_repository/provider.dart';
import 'package:isar_sample/domains/create_action_type.dart';
import 'package:isar_sample/domains/delete_action_type.dart';
import 'package:isar_sample/domains/sort_type.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:isar_sample/presentations/home_screen/components/create_user_bottom_sheet.dart';
import 'package:isar_sample/presentations/home_screen/components/delete_user_bottom_sheet.dart';
import 'package:isar_sample/presentations/home_screen/components/sort_bottom_sheet.dart';
import 'package:isar_sample/presentations/home_screen/components/user_list_tile.dart';
import 'package:isar_sample/presentations/home_screen/home_view_model.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider.notifier);

    final sortType = useState<SortType>(SortType.nameAsc);

    final userList = ref.watch(userListProvider(sortType: sortType.value));

    final isSearchActive = useState(false);

    final searchController = useTextEditingController();

    final displayWidth = MediaQuery.sizeOf(context).width;

    return userList.when(
      data: (value) => Scaffold(
        appBar: AppBar(
          title: const Text('isar_sample'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                SizedBox(
                  height: 60,
                  width: displayWidth,
                  child: ColoredBox(color: Colors.indigo[200]!),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSearchActive.value
                      ? displayWidth
                      // ディスプレイサイズに応じたデフォルトのアイコンサイズを設定
                      : 150,
                  child: isSearchActive.value
                      ? TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                // 検索を終了して検索バーを閉じる
                                isSearchActive.value = false;
                                searchController.clear();
                              },
                            ),
                          ),
                          onSubmitted: (query) {
                            // TODO: 検索処理をここに追加
                            // 検索完了後に閉じる
                            isSearchActive.value = true;
                          },
                        )
                      : Row(
                          children: [
                            IconButton.outlined(
                              icon: const Icon(Icons.search),
                              onPressed: () => isSearchActive.value = true,
                            ),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_alt_rounded),
                            ),
                            IconButton.outlined(
                              onPressed: () =>
                                  selectSortAction(context, sortType),
                              icon: const Icon(Icons.sort),
                            ),
                            const Spacer(),
                          ],
                        ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: const BorderSide(color: Colors.grey),
                        bottom: index == value.length - 1
                            ? const BorderSide(color: Colors.grey)
                            : BorderSide.none,
                      ),
                    ),
                    child: UserListTile(
                      user: value[index],
                      onTap: () => updateUserAction(
                        context,
                        viewModel,
                        value[index],
                      ),
                      onLongPress: () => deleteUserAction(
                        context,
                        viewModel,
                        value[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => deleteUsersAction(context, viewModel, value),
              backgroundColor: Colors.lightBlueAccent,
              child: const Icon(Icons.local_fire_department),
            ),
            const Gap(10),
            FloatingActionButton(
              onPressed: () => createUserAction(context, viewModel),
              backgroundColor: Colors.lightBlueAccent,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('error; $error, stackTrace: $stackTrace'),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

extension on HomeScreen {
  /// ユーザーを追加するアクション
  Future<void> createUserAction(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    // ボトムシートを展開してアクションを選択する
    final result = await CreateUserBottomSheet.show(context);

    if (result == null || !context.mounted) return;

    // オーバーレイにインジケーターを表示
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    overlay.insert(overlayEntry);

    // 作成するユーザー数
    // 視覚的にわかりやすいのは100個
    // パフォーマーンスを計測するなら100000個
    // const number = 100;
    const number = 100000;
    try {
      // ユーザーを作成
      switch (result) {
        case CreateActionType.single:
          await viewModel.create();
        case CreateActionType.batchUseSync:
          await viewModel.createBatch(
            useSync: true,
            number: number,
          );
        case CreateActionType.batchUseAsync:
          await viewModel.createBatch(
            useSync: false,
            number: number,
          );
      }

      // インジケーターを閉じる
      overlayEntry.remove();

      if (!context.mounted) return;
      // スナックバーを表示
      switch (result) {
        case CreateActionType.single:
          showSnackBar(context, 'ユーザーを新規作成しました');
        case CreateActionType.batchUseSync:
          showSnackBar(context, 'ユーザーを同期処理で$number個作成しました');
        case CreateActionType.batchUseAsync:
          showSnackBar(context, 'ユーザーを非同期処理で$number個作成しました');
      }
    } catch (e, s) {
      logger.e('エラー発生', error: e, stackTrace: s);

      // インジケーターを閉じる
      overlayEntry.remove();

      if (!context.mounted) return;
      showSnackBar(context, 'エラーが発生しました');
    }
  }

  /// ユーザーデータを削除するアクショ
  Future<void> deleteUsersAction(
    BuildContext context,
    HomeViewModel viewModel,
    List<User> users,
  ) async {
    // ボトムシートを展開してアクションを選択する
    final result = await DeleteUserBottomSheet.show(context);

    if (result == null || !context.mounted) return;

    // 削除するユーザー数
    const number = 300;
    try {
      // ユーザーを削除して取得
      switch (result) {
        case DeleteActionType.all:
          await viewModel.initUser();
        case DeleteActionType.batchUseSync:
          await viewModel.deleteBatch(
            users: users,
            useSync: true,
            number: number,
          );
        case DeleteActionType.batchUseAsync:
          await viewModel.deleteBatch(
            users: users,
            useSync: false,
            number: number,
          );
      }
      if (!context.mounted) return;

      // スナックバーを表示
      switch (result) {
        case DeleteActionType.all:
          showSnackBar(context, 'ユーザーを全て削除しました');
        case DeleteActionType.batchUseSync:
          showSnackBar(context, 'ユーザーを同期処理で$number個削除しました');
        case DeleteActionType.batchUseAsync:
          showSnackBar(context, 'ユーザーを非同期処理で$number個削除しました');
      }
    } catch (e, s) {
      logger.e('エラー発生', error: e, stackTrace: s);
      if (!context.mounted) return;
      showSnackBar(context, 'エラーが発生しました');
    }
  }

  /// ユーザー情報を更新するアクション
  Future<void> updateUserAction(
    BuildContext context,
    HomeViewModel viewModel,
    User updateUser,
  ) async {
    await viewModel.update(updateUser);
    if (!context.mounted) return;
    showSnackBar(context, '${updateUser.name}を更新しました');
  }

  /// ユーザー情報を削除する処理
  Future<void> deleteUserAction(
    BuildContext context,
    HomeViewModel viewModel,
    User deleteUser,
  ) async {
    await viewModel.delete(deleteUser);
    if (!context.mounted) return;
    showSnackBar(context, '${deleteUser.name}を削除しました');
  }

  /// SnackBarを表示する
  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  Future<void> selectSortAction(
    BuildContext context,
    ValueNotifier<SortType> type,
  ) async {
    final result = await SortBottomSheet.show(
      context,
      type.value,
    );
    if (result == null) return;
    type.value = result;
    // ソート処理
  }
}
