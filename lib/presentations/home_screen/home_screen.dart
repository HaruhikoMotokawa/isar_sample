import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:isar_sample/presentations/home_screen/home_view_model.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    const items = 10;

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
                top: const BorderSide(color: Colors.black12),
                bottom: index == items - 1
                    ? const BorderSide(color: Colors.black12)
                    : BorderSide.none,
              ),
            ),
            child: _UserListTile(
              user: users.value[index],
              onTap: () async {
                final updateUser = users.value[index];
                users.value = await viewModel.updateAndFetchUser(updateUser);
                if (!context.mounted) return;
                showSnackBar(context, '${updateUser.name}を更新しました');
              },
              onLongPress: () async {
                final deleteUserName = users.value[index].name;
                users.value =
                    await viewModel.deleteAndFetchUser(users.value[index]);
                if (!context.mounted) return;
                showSnackBar(context, '$deleteUserNameを削除しました');
              },
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              users.value = await viewModel.initUser();
              if (!context.mounted) return;
              showSnackBar(context, '全てのユーザーを削除しました');
            },
            child: const Icon(Icons.local_fire_department),
          ),
          const Gap(10),
          FloatingActionButton(
            onPressed: () async {
              users.value = await viewModel.createAndFetchUser();
              if (!context.mounted) return;
              showSnackBar(context, 'ユーザーを新規作成しました');
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

extension on HomeScreen {
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
      subtitle: Text('Age: ${user.age}, Hometown: ${user.homeTown.name}'),
      trailing: Icon(
        user.isDrinkingAlcohol ? Icons.local_bar : Icons.no_drinks,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
