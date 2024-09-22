// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'dfef75ddb57bd63c97baff9e40a4e22ad98496f1';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepositoryBase>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepositoryBase>;
String _$userListHash() => r'b7af6196b3292e813cfad13950de6ee27ee6a054';

/// See also [userList].
@ProviderFor(userList)
final userListProvider = AutoDisposeStreamProvider<List<User>>.internal(
  userList,
  name: r'userListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserListRef = AutoDisposeStreamProviderRef<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
