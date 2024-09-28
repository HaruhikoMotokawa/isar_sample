import 'package:flutter/material.dart';
import 'package:isar_sample/domains/delete_action_type.dart';
import 'package:isar_sample/presentations/_shared/action_bottom_sheet.dart';

class DeleteUserBottomSheet extends StatelessWidget {
  const DeleteUserBottomSheet({super.key});

  static Future<DeleteActionType?> show(
    BuildContext context,
  ) async {
    return showModalBottomSheet<DeleteActionType?>(
      context: context,
      builder: (context) {
        return const DeleteUserBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionBottomSheet<DeleteActionType>(
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
  }
}
