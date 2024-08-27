import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/user.dart';
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
            child: _UserListTile(
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
            onPressed: () => initUsersAction(context, viewModel, users),
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
    users.value = await viewModel.createAndFetchUser();
    if (!context.mounted) return;
    showSnackBar(context, 'ユーザーを新規作成しました');
  }

  /// ユーザーデータを初期化するアクショ
  Future<void> initUsersAction(
    BuildContext context,
    HomeViewModel viewModel,
    ValueNotifier<List<User>> users,
  ) async {
    users.value = await viewModel.initUser();
    if (!context.mounted) return;
    showSnackBar(context, '全てのユーザーを削除しました');
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

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
    required this.onTap,
    required this.onLongPress,
  });

  final User user;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age: ${user.age}, Hometown: ${user.homeTown.name}'),
          Text('Pet: ${user.pet.species} (${user.pet.age} years old)'),
          Text('Power Level: ${user.dragonBallCharacter.powerLevel}'),
          if (user.skill != null) ...[
            Text('Skill: ${user.skill!.name}'),
            Text('Description: ${user.skill!.description ?? "No description"}'),
            Text('Experience: ${user.skill!.yearsOfExperience} years'),
          ],
        ],
      ),
      trailing: Icon(
        user.isDrinkingAlcohol ? Icons.local_bar : Icons.no_drinks,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: switch (user.homeTown) {
        HomeTown.Fukuoka => Colors.red,
        HomeTown.Osaka => Colors.brown,
        HomeTown.Tokyo => Colors.green,
        HomeTown.Kyoto => Colors.yellow,
        HomeTown.Sapporo => Colors.purple,
        HomeTown.Sendai => Colors.orange,
      },
    );
  }
}
