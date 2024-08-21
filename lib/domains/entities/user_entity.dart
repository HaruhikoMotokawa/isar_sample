// ignore_for_file: constant_identifier_names, public_member_api_docs

import 'package:isar/isar.dart';
import 'package:isar_sample/domains/user.dart';

part 'user_entity.g.dart'; // Isarコードジェネレーターが生成するファイル

@collection
@Name('User')
class UserEntity {
  Id id = Isar.autoIncrement; // 自動インクリメントされるID
  late String name;
  late int age;
  late bool isDrinkingAlcohol;
  @Enumerated(EnumType.name)
  late HomeTown homeTown;
}
