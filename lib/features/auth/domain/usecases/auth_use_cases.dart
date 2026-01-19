import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';
import 'package:grocery_app/features/auth/domain/repo/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  // 1. Send OTP
  Future<String> sendOtp(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }

  // 2. Verify OTP
  Future<UserCredential> verifyOtp(
    String smsCode,
    String verificationId,
  ) async {
    return await repository.verifyOtp(smsCode, verificationId);
  }

  // 3. Create User
  Future<void> createUser(UserEntity user) async {
    await repository.createUser(user);
  }

  // 4. Get User By ID
  Future<UserEntity?> getUserById(String userId) async {
    return await repository.getUserById(userId);
  }

  // 5. Update User
  Future<void> updateUser(UserEntity user) async {
    await repository.updateUser(user);
  }

  // 7. Logout
  Future<void> logout() async {
    await repository.logout();
  }

  // 8. Get Current User
  User? getCurrentUser() {
    return repository.getCurrentUser();
  }
}
