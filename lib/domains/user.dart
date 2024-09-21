import 'dart:math';

import 'package:isar_sample/domains/dragon_ball_character.dart';
import 'package:isar_sample/domains/entities/user_entity.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/pet.dart';

/// アプリ上で扱うユーザーの情報の型
/// 正確にはアプリケーション層とプレゼンテーション層で扱うユーザーの情報の型
class User {
  User({
    required this.name,
    required this.age,
    required this.isDrinkingAlcohol,
    required this.homeTown,
    required this.dragonBallCharacter,
    this.pets,
    this.id,
    this.skill,
  });

  /// ランダムな値でUserオブジェクトを生成するファクトリメソッド
  User.random()
      : id = null,
        name = String.fromCharCodes(
          List.generate(5, (_) => Random().nextInt(26) + 65),
        ),
        age = Random().nextInt(43) + 18,
        isDrinkingAlcohol = Random().nextBool(),
        homeTown = HomeTown.values[Random().nextInt(HomeTown.values.length)],
        skill = Random().nextBool()
            ? null
            : Skill(
                name: 'Skill ${Random().nextInt(100)}',
                description: 'A random skill',
                yearsOfExperience: Random().nextInt(10),
              ),
        pets = Random().nextInt(4) == 0
            ? null
            : List<Pet>.generate(
                Random().nextInt(3) + 1, // 1 ~ 3 つのペットを生成
                (_) => Pet.values[Random().nextInt(Pet.values.length)],
              ),
        dragonBallCharacter = DragonBallCharacter
            .values[Random().nextInt(DragonBallCharacter.values.length)];

  final int? id;
  final String name;
  final int age;
  final bool isDrinkingAlcohol;
  final HomeTown homeTown;
  final List<Pet>? pets;
  final DragonBallCharacter dragonBallCharacter;
  final Skill? skill;

  /// ユーザー情報の一部を変更して新しいUserオブジェクトを作成するメソッド
  User copyWith({
    int? id,
    String? name,
    int? age,
    bool? isDrinkingAlcohol,
    HomeTown? homeTown,
    List<Pet>? pets,
    DragonBallCharacter? dragonBallCharacter,
    Skill? skill,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      isDrinkingAlcohol: isDrinkingAlcohol ?? this.isDrinkingAlcohol,
      homeTown: homeTown ?? this.homeTown,
      pets: pets ?? this.pets,
      dragonBallCharacter: dragonBallCharacter ?? this.dragonBallCharacter,
      skill: skill ?? this.skill,
    );
  }

  /// ランダムな値で指定されたユーザー情報を更新するメソッド
  User createUpdatedUser() {
    final randomUser = User.random();
    return copyWith(
      age: randomUser.age,
      isDrinkingAlcohol: randomUser.isDrinkingAlcohol,
      homeTown: randomUser.homeTown,
      pets: randomUser.pets,
      dragonBallCharacter: randomUser.dragonBallCharacter,
      skill: randomUser.skill,
    );
  }
}
