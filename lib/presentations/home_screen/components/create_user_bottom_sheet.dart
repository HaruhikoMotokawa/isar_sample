import 'package:flutter/material.dart';
import 'package:isar_sample/domains/create_action_type.dart';
import 'package:isar_sample/presentations/_shared/action_bottom_sheet.dart';

class CreateUserBottomSheet extends StatelessWidget {
  const CreateUserBottomSheet({super.key});

  static Future<CreateActionType?> show(
    BuildContext context,
  ) async {
    return showModalBottomSheet<CreateActionType?>(
      context: context,
      builder: (context) {
        return const CreateUserBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionBottomSheet<CreateActionType>(
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
  }
}
