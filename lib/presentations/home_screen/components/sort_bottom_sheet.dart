import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:isar_sample/domains/sort_type.dart';

class SortBottomSheet extends HookWidget {
  const SortBottomSheet(this.type, {super.key});

  static Future<SortType?> show(
    BuildContext context,
    SortType type,
  ) async {
    return showModalBottomSheet<SortType?>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SortBottomSheet(type);
      },
    );
  }

  final SortType type;
  @override
  Widget build(BuildContext context) {
    final currentType = useState<SortType>(type);

    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    final displayWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Padding(
        padding: bottomSafeArea == 0
            ? const EdgeInsets.only(bottom: 20)
            : EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Column(
            children: [
              _ListTile(notifier: currentType, sortType: SortType.nameAsc),
              _ListTile(notifier: currentType, sortType: SortType.nameDesc),
              _ListTile(notifier: currentType, sortType: SortType.ageAsc),
              _ListTile(notifier: currentType, sortType: SortType.ageDesc),
              _ListTile(notifier: currentType, sortType: SortType.hometown),
              _ListTile(
                notifier: currentType,
                sortType: SortType.dragonBallCharacter,
              ),
              SizedBox(
                width: displayWidth - 40,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(currentType.value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('確定'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.notifier,
    required this.sortType,
  });

  final ValueNotifier<SortType> notifier;
  final SortType sortType;

  @override
  Widget build(BuildContext context) {
    return RadioListTile.adaptive(
      title: Text(sortType.description),
      controlAffinity: ListTileControlAffinity.trailing,
      useCupertinoCheckmarkStyle: true,
      value: sortType,
      groupValue: notifier.value,
      onChanged: (value) {
        notifier.value = sortType;
      },
    );
  }
}
