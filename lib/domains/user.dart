// ignore_for_file: public_member_api_docs, constant_identifier_names

class User {
  User({
    required this.name,
    required this.age,
    required this.isDrinkingAlcohol,
    required this.homeTown,
    this.id,
  });
  final int? id;
  final String name;
  final int age;
  final bool isDrinkingAlcohol;
  final HomeTown homeTown;

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
}

enum HomeTown {
  Tokyo,
  Osaka,
  Kyoto,
  Sapporo,
  Fukuoka,
  Sendai,
}
