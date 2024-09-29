import 'package:isar_sample/data/repositories/user_repository/repository.dart';
import 'package:isar_sample/domains/filter_type.dart';
import 'package:isar_sample/domains/sort_type.dart';
import 'package:isar_sample/domains/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
UserRepositoryBase userRepository(UserRepositoryRef ref) {
  return UserRepository(ref);
}

@riverpod
Stream<List<User>> userList(
  UserListRef ref, {
  required SortType sortType,
  List<FilterType>? filters,
}) {
  return ref
      .read(userRepositoryProvider)
      .watch(sortType: sortType, filters: filters);
}
