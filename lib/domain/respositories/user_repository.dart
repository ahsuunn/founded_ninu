import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<UserEntity?> getUserById(String uid);
}
