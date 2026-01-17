import 'package:flutter/material.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';

class AlreadyHaveAnAccountText extends StatelessWidget {
  const AlreadyHaveAnAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.loginScreen);
      },
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: AppTextStyles.font16GraySemiBold,
          children: [
            TextSpan(
              text: 'Login',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
