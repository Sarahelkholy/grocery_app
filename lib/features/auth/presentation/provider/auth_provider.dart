// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/core/theming/colors.dart';
import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';
import 'package:grocery_app/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:grocery_app/features/location/presentation/provider/location_provider.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCases authUseCases;

  AuthProvider(this.authUseCases);

  String smsOtp = '';
  String? verificationId;

  String error = '';
  bool isLoading = false;

  double? _pendingLat;
  double? _pendingLng;
  String? _pendingAddress;

  // Step 1: Send OTP
  Future<void> sendOtp(BuildContext context, String phoneNumber) async {
    try {
      isLoading = true;
      notifyListeners();

      log("Sending OTP to: $phoneNumber");

      final id = await authUseCases.sendOtp(phoneNumber);

      if (id.isEmpty) {
        throw Exception("Verification ID is null or empty");
      }

      verificationId = id;
      log("Verification ID received: $verificationId");

      isLoading = false;
      notifyListeners();

      await _showOtpDialog(context, phoneNumber);
    } catch (e) {
      log("OTP Error: $e");
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  // Step 2: Show OTP Dialog
  Future<void> _showOtpDialog(BuildContext context, String phoneNumber) async {
    TextEditingController otpController = TextEditingController();
    String localError = '';
    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Enter OTP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                cursorColor: ColorsManager.gray,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsManager.lightgray),
                  borderRadius: BorderRadius.circular(8),
                ),
                controller: otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                placeholder: 'OTP',
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                  if (localError.isNotEmpty) {
                    setState(() => localError = '');
                  }
                },
              ),
              if (localError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    localError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      setState(() => localError = '');
                      context.pop();
                    },
              child: const Text(
                'Cancel',
                style: TextStyle(color: ColorsManager.gray),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorsManager.lightYellow,
                foregroundColor: Colors.white,
              ),
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final code = otpController.text.trim();

                      if (code.length != 6) {
                        setState(() {
                          localError = 'Please enter a valid 6-digit OTP';
                        });
                        return;
                      }

                      if (verificationId == null) {
                        setState(() {
                          localError = 'Verification ID not found';
                        });
                        return;
                      }

                      setState(() {
                        isSubmitting = true;
                        localError = '';
                      });

                      try {
                        UserCredential credential = await authUseCases
                            .verifyOtp(code, verificationId!);

                        User? user = credential.user;
                        if (user != null) {
                          final newUser = UserEntity(
                            id: user.uid,

                            phoneNumber: user.phoneNumber!,
                          );
                          final userId = user.uid;
                          final existingUser = await authUseCases.getUserById(
                            userId,
                          );

                          if (existingUser == null) {
                            await authUseCases.createUser(newUser);
                          }

                          await savePendingLocationIfExists();
                          await loadUserLocationToProvider(context);

                          context.pop();
                          context.pushReplacementNamed(Routes.homeScreen);
                        } else {
                          setState(() {
                            localError = 'Failed to sign in';
                          });
                          otpController.clear();
                        }
                      } catch (e) {
                        log("OTP Verification Error: $e");
                        setState(() {
                          localError = 'Invalid OTP. Please try again.';
                          otpController.clear();
                        });
                      } finally {
                        setState(() {
                          isSubmitting = false;
                        });
                      }
                    },
              child: isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUserLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final firebaseUser = authUseCases.getCurrentUser();
      if (firebaseUser == null) throw Exception("User not logged in");

      final updatedUser = UserEntity(
        id: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber!,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      await authUseCases.updateUser(updatedUser);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  void setPendingLocation({
    required double lat,
    required double lng,
    required String address,
  }) {
    _pendingLat = lat;
    _pendingLng = lng;
    _pendingAddress = address;
  }

  Future<void> savePendingLocationIfExists() async {
    if (_pendingLat != null && _pendingLng != null && _pendingAddress != null) {
      await updateUserLocation(
        latitude: _pendingLat!,
        longitude: _pendingLng!,
        address: _pendingAddress!,
      );

      _pendingLat = null;
      _pendingLng = null;
      _pendingAddress = null;
    }
  }

  Future<void> loadUserLocationToProvider(BuildContext context) async {
    final firebaseUser = authUseCases.getCurrentUser();
    if (firebaseUser == null) return;

    final user = await authUseCases.getUserById(firebaseUser.uid);
    if (user == null) return;

    if (user.latitude != null && user.longitude != null) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      locationProvider.setLocationFromFirestore(
        lat: user.latitude!,
        lng: user.longitude!,
        address: user.address,
      );
    }
  }
}
