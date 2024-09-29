import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:isar_sample/domains/filter_type.dart';

class FilterBottomSheet extends HookWidget {
  const FilterBottomSheet(this.types, {super.key});

  static Future<List<FilterType>?> show(
    BuildContext context,
    List<FilterType> types,
  ) async {
    return showModalBottomSheet<List<FilterType>?>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return FilterBottomSheet(types);
      },
    );
  }

  final List<FilterType> types;

  @override
  Widget build(BuildContext context) {
    final activeFilters = useState<List<FilterType>>([...types]);

    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    final displayWidth = MediaQuery.sizeOf(context).width;

    final displayHeight = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: SizedBox(
        height: displayHeight * 0.9,
        child: Padding(
          padding: bottomSafeArea == 0
              ? const EdgeInsets.only(bottom: 20)
              : EdgeInsets.zero,
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  '絞り込み',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    const ListTile(
                      title: Text('年齢', style: TextStyle(fontSize: 18)),
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.young,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.middleAged,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.elderly,
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('出身地', style: TextStyle(fontSize: 18)),
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originSapporo,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originSendai,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originTokyo,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originOsaka,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originKyoto,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.originFukuoka,
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('飼っているペット', style: TextStyle(fontSize: 18)),
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.ownsDog,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.ownsCat,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.ownsRabbit,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.ownsParrot,
                    ),
                    _ListTile(
                      notifier: activeFilters,
                      filterType: FilterType.ownsHamster,
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Gap(10),
              SizedBox(
                width: displayWidth - 40,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        // activeFiltersを空にする
                        onPressed: () => activeFilters.value = [],
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('リセット'),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(activeFilters.value),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTile extends HookWidget {
  const _ListTile({
    required this.notifier,
    required this.filterType,
  });

  final ValueNotifier<List<FilterType>> notifier;
  final FilterType filterType;

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(false);
    useEffect(
      () {
        isChecked.value = notifier.value.contains(filterType);
        return null;
      },
      [notifier.value],
    );

    return CheckboxListTile.adaptive(
      title: Text(filterType.description),
      value: isChecked.value,
      onChanged: (value) {
        isChecked.value = value!;
        if (value) {
          notifier.value = [...notifier.value, filterType];
        } else {
          notifier.value =
              notifier.value.where((e) => e != filterType).toList();
        }
      },
    );
  }
}
