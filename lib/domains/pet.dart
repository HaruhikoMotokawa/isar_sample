enum Pet {
  dog('Dog', 5),
  cat('Cat', 3),
  rabbit('Rabbit', 2),
  parrot('Parrot', 4),
  hamster('Hamster', 1);

  const Pet(this.species, this.age);

  final String species; // ペットの種類
  final int age; // ペットの年齢
}
