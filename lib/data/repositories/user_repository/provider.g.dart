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
String _$userListHash() => r'2634abe8a416c691e94b4870ef829c80c4fe4ce3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userList].
@ProviderFor(userList)
const userListProvider = UserListFamily();

/// See also [userList].
class UserListFamily extends Family<AsyncValue<List<User>>> {
  /// See also [userList].
  const UserListFamily();

  /// See also [userList].
  UserListProvider call({
    required SortType sortType,
    List<FilterType>? filters,
  }) {
    return UserListProvider(
      sortType: sortType,
      filters: filters,
    );
  }

  @override
  UserListProvider getProviderOverride(
    covariant UserListProvider provider,
  ) {
    return call(
      sortType: provider.sortType,
      filters: provider.filters,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userListProvider';
}

/// See also [userList].
class UserListProvider extends AutoDisposeStreamProvider<List<User>> {
  /// See also [userList].
  UserListProvider({
    required SortType sortType,
    List<FilterType>? filters,
  }) : this._internal(
          (ref) => userList(
            ref as UserListRef,
            sortType: sortType,
            filters: filters,
          ),
          from: userListProvider,
          name: r'userListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userListHash,
          dependencies: UserListFamily._dependencies,
          allTransitiveDependencies: UserListFamily._allTransitiveDependencies,
          sortType: sortType,
          filters: filters,
        );

  UserListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sortType,
    required this.filters,
  }) : super.internal();

  final SortType sortType;
  final List<FilterType>? filters;

  @override
  Override overrideWith(
    Stream<List<User>> Function(UserListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserListProvider._internal(
        (ref) => create(ref as UserListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sortType: sortType,
        filters: filters,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<User>> createElement() {
    return _UserListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserListProvider &&
        other.sortType == sortType &&
        other.filters == filters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sortType.hashCode);
    hash = _SystemHash.combine(hash, filters.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserListRef on AutoDisposeStreamProviderRef<List<User>> {
  /// The parameter `sortType` of this provider.
  SortType get sortType;

  /// The parameter `filters` of this provider.
  List<FilterType>? get filters;
}

class _UserListProviderElement
    extends AutoDisposeStreamProviderElement<List<User>> with UserListRef {
  _UserListProviderElement(super.provider);

  @override
  SortType get sortType => (origin as UserListProvider).sortType;
  @override
  List<FilterType>? get filters => (origin as UserListProvider).filters;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
