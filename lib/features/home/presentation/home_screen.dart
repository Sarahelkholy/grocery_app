import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            context.pushReplacementNamed(Routes.loginScreen);
          },
          child: Text('Signout'),
        ),
      ),
    );
  }
}
