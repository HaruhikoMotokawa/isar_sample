import 'dart:math';

import 'package:isar_sample/domains/home_town.dart';

/// アプリ上で扱うユーザーの情報の型
/// 正確にはアプリケーション層とプレゼンテーション層で扱うユーザーの情報の型
class User {
  User({
    required this.name,
    required this.age,
    required this.isDrinkingAlcohol,
    required this.homeTown,
    this.id,
  });

  /// ランダムな値でUserオブジェクトを生成するファクトリメソッド
  User.random()
      : name = String.fromCharCodes(
          List.generate(5, (_) => Random().nextInt(26) + 65),
        ),
        age = Random().nextInt(43) + 18,
        isDrinkingAlcohol = Random().nextBool(),
        homeTown = HomeTown.values[Random().nextInt(HomeTown.values.length)],
        id = null;

  final int? id;
  final String name;
  final int age;
  final bool isDrinkingAlcohol;
  final HomeTown homeTown;

  /// ユーザー情報の一部を変更して新しいUserオブジェクトを作成するメソッド
  /// 指定されたプロパティのみが更新され、指定されていないプロパティは元の値が引き継がれる
  User copyWith({
    int? id,
    String? name,
    int? age,
    bool? isDrinkingAlcohol,
    HomeTown? homeTown,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      isDrinkingAlcohol: isDrinkingAlcohol ?? this.isDrinkingAlcohol,
      homeTown: homeTown ?? this.homeTown,
    );
  }

  /// ランダムな値で指定されたユーザー情報を更新するメソッド
  /// IDと名前はそのままに、他のプロパティをランダムに更新します
  User createUpdatedUser() {
    final randomUser = User.random();
    return copyWith(
      age: randomUser.age,
      isDrinkingAlcohol: randomUser.isDrinkingAlcohol,
      homeTown: randomUser.homeTown,
    );
  }
}
