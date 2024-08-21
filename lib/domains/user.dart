// ignore_for_file: public_member_api_docs, constant_identifier_names

class User {
  User({
    required this.name,
    required this.age,
    required this.isDrinkingAlcohol,
    required this.homeTown,
  });
  final String name;
  final int age;
  final bool isDrinkingAlcohol;
  final HomeTown homeTown;
}

enum HomeTown {
  Tokyo,
  Osaka,
  Kyoto,
  Sapporo,
  Fukuoka,
  Sendai,
}
