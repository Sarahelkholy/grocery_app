import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/di/dependency_injection.dart';
import 'package:grocery_app/core/helpers/constants.dart';
import 'package:grocery_app/core/routing/app_router.dart';
import 'package:grocery_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:grocery_app/firebase_options.dart';
import 'package:grocery_app/grocery_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupDependencies();
  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => getIt<AuthProvider>())],
      child: GroceryApp(appRouter: AppRouter()),
    ),
  );
}

checkIfLoggedInUser() async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      log('User is currently signed out!');
      isLoggedInUser = false;
    } else {
      log('User is signed in!');
      isLoggedInUser = true;
    }
  });
}
