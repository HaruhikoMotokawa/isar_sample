import 'package:isar_sample/data/local_sources/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // アプリ起動前に初期化したい処理を書く
  await ref.read(isarProvider.future);
}
