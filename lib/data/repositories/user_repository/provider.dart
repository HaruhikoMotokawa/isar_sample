import 'package:isar_sample/data/repositories/user_repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
UserRepositoryBase userRepository(UserRepositoryRef ref) {
  return UserRepository(ref);
}
