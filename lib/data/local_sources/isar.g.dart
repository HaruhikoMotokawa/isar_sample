// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'407eccf2ff271299b58e86d18fd500604e86b151';

/// Isarデータベースのインスタンスを提供するリバー・ポッドプロバイダー。
/// このプロバイダーは`keepAlive`が`true`に設定されており、アプリケーションのライフサイクル全体で
/// Isarインスタンスを保持します。
///
/// 戻り値:
/// Isarインスタンスを非同期で返します。
///
/// Copied from [isar].
@ProviderFor(isar)
final isarProvider = FutureProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = FutureProviderRef<Isar>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
