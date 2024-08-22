import 'package:isar/isar.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final dbPath = appDocumentDir.path;

  return openIsar(dbPath);
}

Future<Isar> openIsar(String dbPath, {String name = Isar.defaultName}) async {
  return Isar.open(
    [UserEntitySchema],
    directory: dbPath,
    name: name,
  );
}
