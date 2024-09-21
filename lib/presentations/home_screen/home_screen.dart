import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_sample/core/log/logger.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:isar_sample/presentations/home_screen/components/action_bottom_sheet.dart';
import 'package:isar_sample/presentations/home_screen/components/user_list_tile.dart';
import 'package:isar_sample/presentations/home_screen/home_view_model.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider.notifier);

    final users = useState<List<User>>([]);

    useEffect(
      () {
        viewModel.fetchAllUsers().then((fetchUsers) {
          users.value = fetchUsers;
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('isar_sample'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
        itemCount: users.value.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: const BorderSide(color: Colors.grey),
                bottom: index == users.value.length - 1
                    ? const BorderSide(color: Colors.grey)
                    : BorderSide.none,
              ),
            ),
            child: UserListTile(
              user: users.value[index],
              onTap: () => updateUserAction(
                context,
                viewModel,
                users,
                users.value[index],
              ),
              onLongPress: () => deleteUserAction(
                context,
                viewModel,
                users,
                users.value[index],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => deleteUsersAction(context, viewModel, users),
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.local_fire_department),
          ),
          const Gap(10),
          FloatingActionButton(
            onPressed: () => createUserAction(context, viewModel, users),
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

extension on HomeScreen {
  /// ユーザーを追加するアクション
  Future<void> createUserAction(
    BuildContext context,
    HomeViewModel viewModel,
    ValueNotifier<List<User>> users,
  ) async {
    // ボトムシートを展開してアクションを選択する
    final result = await ActionBottomSheet.show<CreateActionType>(
      context,
      actions: [
        ActionItem(
          icon: Icons.person,
          text: 'Single',
          onTap: () => CreateActionType.single,
        ),
        ActionItem(
          icon: Icons.people,
          text: 'Batch',
          onTap: () => CreateActionType.batchUseSync,
        ),
        ActionItem(
          icon: Icons.people,
          text: 'Batch(Async)',
          onTap: () => CreateActionType.batchUseAsync,
        ),
      ],
    );

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
    const number = 100000;
    try {
      // ユーザーを作成して取得
      switch (result) {
        case CreateActionType.single:
          users.value = await viewModel.createAndFetchUser();
        case CreateActionType.batchUseSync:
          users.value = await viewModel.createBatchAndFetchUser(
            useSync: true,
            number: number,
          );
        case CreateActionType.batchUseAsync:
          users.value = await viewModel.createBatchAndFetchUser(
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
      overlayEntry.remove();
      if (!context.mounted) return;
      showSnackBar(context, 'エラーが発生しました');
    }
  }

  /// ユーザーデータを削除するアクショ
  Future<void> deleteUsersAction(
    BuildContext context,
    HomeViewModel viewModel,
    ValueNotifier<List<User>> users,
  ) async {
    // ボトムシートを展開してアクションを選択する
    final result = await ActionBottomSheet.show<DeleteActionType>(
      context,
      actions: [
        ActionItem(
          icon: Icons.person,
          text: 'all',
          onTap: () => DeleteActionType.all,
        ),
        ActionItem(
          icon: Icons.people,
          text: 'Batch',
          onTap: () => DeleteActionType.batchUseSync,
        ),
        ActionItem(
          icon: Icons.people,
          text: 'Batch(Async)',
          onTap: () => DeleteActionType.batchUseAsync,
        ),
      ],
    );

    if (result == null || !context.mounted) return;
    // オーバーレイにインジケーターを表示
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    overlay.insert(overlayEntry);

    // 削除するユーザー数
    const number = 300;
    try {
      // ユーザーを削除して取得
      switch (result) {
        case DeleteActionType.all:
          users.value = await viewModel.initUser();
        case DeleteActionType.batchUseSync:
          users.value = await viewModel.deleteBatchAndFetchUser(
            users: users.value,
            useSync: true,
            number: number,
          );
        case DeleteActionType.batchUseAsync:
          users.value = await viewModel.deleteBatchAndFetchUser(
            users: users.value,
            useSync: false,
            number: number,
          );
      }
      if (!context.mounted) return;
      // インジケーターを閉じる
      overlayEntry.remove();
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
      overlayEntry.remove();
      if (!context.mounted) return;
      showSnackBar(context, 'エラーが発生しました');
    }
  }

  /// ユーザー情報を更新するアクション
  Future<void> updateUserAction(
    BuildContext context,
    HomeViewModel viewModel,
    ValueNotifier<List<User>> users,
    User updateUser,
  ) async {
    users.value = await viewModel.updateAndFetchUser(updateUser);
    if (!context.mounted) return;
    showSnackBar(context, '${updateUser.name}を更新しました');
  }

  /// ユーザー情報を削除する処理
  Future<void> deleteUserAction(
    BuildContext context,
    HomeViewModel viewModel,
    ValueNotifier<List<User>> users,
    User deleteUser,
  ) async {
    users.value = await viewModel.deleteAndFetchUser(deleteUser);
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
}

enum CreateActionType {
  single,
  batchUseSync,
  batchUseAsync,
}

enum DeleteActionType {
  all,
  batchUseSync,
  batchUseAsync,
}
