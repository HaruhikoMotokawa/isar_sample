import 'package:flutter/material.dart';

class ActionBottomSheet<T> extends StatelessWidget {
  const ActionBottomSheet({
    required this.actions,
    super.key,
  });

  final List<ActionItem> actions;

  static Future<T?> show<T>(
    BuildContext context, {
    required List<ActionItem<T>> actions,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) {
        return ActionBottomSheet<T>(actions: actions);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: actions,
      ),
    );
  }
}

class ActionItem<T> extends StatelessWidget {
  const ActionItem({
    required this.icon,
    required this.text,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String text;
  final T Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
        ),
        title: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onTap: () {
          final result = onTap?.call();
          Navigator.pop(context, result);
        },
      ),
    );
  }
}
