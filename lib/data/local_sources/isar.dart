import 'package:isar/isar.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar.g.dart';

/// Isarデータベースのインスタンスを提供するリバー・ポッドプロバイダー。
/// このプロバイダーは`keepAlive`が`true`に設定されており、アプリケーションのライフサイクル全体で
/// Isarインスタンスを保持します。
///
/// 戻り値:
/// Isarインスタンスを非同期で返します。
@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  // アプリケーションのドキュメントディレクトリを取得
  final appDocumentDir = await getApplicationDocumentsDirectory();
  // データベースファイルのディレクトリパスを取得
  final dbPath = appDocumentDir.path;

  return openIsar(dbPath);
}

/// 指定されたディレクトリパスにIsarデータベースを開きIsarインスタンスを返す
///
/// [dbPath] - データベースファイルのディレクトリパス。
/// [name] - （オプション）Isarインスタンスの名前。デフォルトは[Isar.defaultName]。
///
/// 戻り値:
/// Isarインスタンスを非同期で返します。
Future<Isar> openIsar(String dbPath, {String name = Isar.defaultName}) async {
  return Isar.open(
    [UserEntitySchema], // 使用するIsarスキーマを指定
    directory: dbPath, // データベースのディレクトリパスを指定
    name: name, // データベースの名前を指定（デフォルトはIsarのデフォルト名）
  );
}
