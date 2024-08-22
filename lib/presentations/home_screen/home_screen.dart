import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const items = 10;
    return Scaffold(
      appBar: AppBar(
        title: const Text('isar_sample'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
        itemCount: items,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: const BorderSide(color: Colors.black12),
                bottom: index == items - 1
                    ? const BorderSide(color: Colors.black12)
                    : BorderSide.none,
              ),
            ),
            child: ListTile(
              title: const Text('text'),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.local_fire_department),
          ),
          const Gap(10),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.refresh),
          ),
          const Gap(10),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
