// ignore_for_file: constant_identifier_names, public_member_api_docs

import 'package:isar/isar.dart';
import 'package:isar_sample/domains/dragon_ball_character.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/pet.dart';

part 'user_entity.g.dart'; // Isarコードジェネレーターが生成するファイル

/// Isarで扱うユーザーの情報の型
// Isarのエンティティクラスには、@collectionをつける
@collection
// @nameをつけることで、Isarのコレクション名を指定できる
@Name('User')
class UserEntity {
  // IsarのautoIncrementを使うことで、自動採番を行うことができる
  Id id = Isar.autoIncrement;
  late String name;
  late int age;
  late bool isDrinkingAlcohol;
  // EnumTypeを指定することで、列挙型を保存できる
  @Enumerated(EnumType.name)
  late HomeTown homeTown;

  /// 飼っているペット
  ///
  /// 複数のプロパティを持つ列挙型を保存する場合、EnumType.nameを指定する
  @Enumerated(EnumType.name)
  late Pet pet;

  /// ドラゴンボールのキャラクターに例えた戦闘力
  ///
  /// EnumType.valueを指定することで、列挙型の値を保存できる
  /// EnumType.valueでするpropertyはStringで指定するのでタイポに注意
  @Enumerated(EnumType.value, 'powerLevel')
  late DragonBallCharacter dragonBallCharacter;

  /// ユーザーのスキル
  late Skill? skill;
}

/// ユーザーのスキル情報の型
///
/// 埋め込みオブジェクトは、Isarで扱うエンティティクラスに@embeddedをつける
/// 埋め込みオブジェクトの制約としてパラメータにrequiredをつけることができない
@embedded
class Skill {
  Skill({
    this.name,
    this.description,
    this.yearsOfExperience,
  });

  final String? name; // 特技の名前
  final String? description; // 特技の説明
  final int? yearsOfExperience; // 経験年数
}
