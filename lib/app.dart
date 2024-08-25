import 'package:flutter/material.dart';
import 'package:isar_sample/presentations/app_start_up/app_start_up_screen.dart';
import 'package:isar_sample/presentations/home_screen/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppStartupScreen(
        onLoaded: (context) => const HomeScreen(),
      ),
    );
  }
}
