import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  // auth datasource
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<UserEntity?> getUserById(String userId);

  // Firebase Auth
  Future<String> sendOtp(String phoneNumber);
  Future<UserCredential> verifyOtp(String smsCode, String verificationId);
  Future<void> logout();
  User? getCurrentUser();
}
