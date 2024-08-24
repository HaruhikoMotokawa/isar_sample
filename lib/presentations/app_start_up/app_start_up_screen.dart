import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_sample/presentations/app_start_up/provider.dart';

/// 初期化を待つためのウィジェット
class AppStartupScreen extends ConsumerWidget {
  const AppStartupScreen({required this.onLoaded, super.key});

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return switch (appStartupState) {
      AsyncData() => onLoaded(context),
      AsyncError(:final error) => _AppStartUpError(error: error),
      _ => const _AppStartUpLoading(),
    };
  }
}

class _AppStartUpLoading extends StatelessWidget {
  const _AppStartUpLoading();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _AppStartUpError extends ConsumerWidget {
  const _AppStartUpError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(appStartupProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
