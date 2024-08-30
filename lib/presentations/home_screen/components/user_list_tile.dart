import 'package:flutter/material.dart';
import 'package:isar_sample/domains/home_town.dart';
import 'package:isar_sample/domains/user.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    required this.user,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final User user;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age: ${user.age}, Hometown: ${user.homeTown.name}'),
          Text('Pet: ${user.pet.species} (${user.pet.age} years old)'),
          Text('Power Level: ${user.dragonBallCharacter.powerLevel}'),
          if (user.skill != null) ...[
            Text('Skill: ${user.skill!.name}'),
            Text('Description: ${user.skill!.description ?? "No description"}'),
            Text('Experience: ${user.skill!.yearsOfExperience} years'),
          ],
        ],
      ),
      trailing: Icon(
        user.isDrinkingAlcohol ? Icons.local_bar : Icons.no_drinks,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: switch (user.homeTown) {
        HomeTown.Fukuoka => Colors.red,
        HomeTown.Osaka => Colors.brown,
        HomeTown.Tokyo => Colors.green,
        HomeTown.Kyoto => Colors.yellow,
        HomeTown.Sapporo => Colors.purple,
        HomeTown.Sendai => Colors.orange,
      },
    );
  }
}
