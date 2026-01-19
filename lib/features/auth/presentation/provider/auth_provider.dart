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

class AuthProvider with ChangeNotifier {
  final AuthUseCases authUseCases;

  AuthProvider(this.authUseCases);

  String smsOtp = '';
  String? verificationId;
  String error = '';
  bool isLoading = false;

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

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
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
                  child: Text(localError, style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => localError = '');
                context.pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: ColorsManager.gray),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorsManager.lightYellow,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final code = otpController.text.trim();

                if (code.length != 6) {
                  setState(
                    () => localError = 'Please enter a valid 6-digit OTP',
                  );
                  return;
                }

                if (verificationId == null) {
                  setState(() => localError = 'Verification ID not found');
                  return;
                }

                try {
                  UserCredential credential = await authUseCases.verifyOtp(
                    code,
                    verificationId!,
                  );

                  User? user = credential.user;
                  if (user != null) {
                    final newUser = UserEntity(phoneNumber: user.phoneNumber!);
                    await authUseCases.createUser(newUser);

                    context.pop();
                    context.pushReplacementNamed(Routes.homeScreen);
                  } else {
                    setState(() => localError = 'Failed to sign in');
                    otpController.clear();
                  }
                } catch (e) {
                  log("OTP Verification Error: $e");
                  setState(() {
                    localError = 'Invalid OTP. Please try again.';
                    otpController.clear();
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
