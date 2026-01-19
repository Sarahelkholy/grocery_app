import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:grocery_app/features/auth/data/models/user_model.dart';
import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';
import 'package:grocery_app/features/auth/domain/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;
  final FirebaseAuth _auth;

  AuthRepositoryImpl(this._auth, this._authDatasource);

  // Create user
  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _authDatasource.createUser(userModel);
  }

  // Update user
  @override
  Future<void> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _authDatasource.updateUser(userModel);
  }

  // Get user by ID
  @override
  Future<UserEntity?> getUserById(String userId) async {
    final userModel = await _authDatasource.getUserById(userId);
    return userModel?.toEntity();
  }

  // ================= OTP =================
  @override
  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification (rare)
      },

      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e.message ?? "Verification failed");
      },

      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
    );

    return completer.future;
  }

  @override
  Future<UserCredential> verifyOtp(
    String smsCode,
    String verificationId,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> logout() async => await _auth.signOut();

  @override
  User? getCurrentUser() => _auth.currentUser;
}
