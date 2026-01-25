import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/features/auth/presentation/provider/auth_provider.dart'
    as my_auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = value.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back!', style: AppTextStyles.font24BlackBold),
            verticalSpace(10),
            Text(
              'Enter your Phone Number to continue',
              style: AppTextStyles.font16GraySemiBold,
            ),
            verticalSpace(50),

            Form(
              key: _formKey,
              child: TextFormField(
                cursorColor: ColorsManager.gray,
                onTapOutside: ((event) {
                  FocusScope.of(context).unfocus();
                }),
                autofocus: true,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 15.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: ColorsManager.gray,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: ColorsManager.lightYellow,
                      width: 1.5,
                    ),
                  ),
                  prefixText: "+20 ",
                  prefixStyle: AppTextStyles.font16GraySemiBold,
                  labelText: 'Phone Number',
                  labelStyle: AppTextStyles.font16GraySemiBold,
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
                onChanged: _validatePhone,
              ),
            ),

            verticalSpace(50),

            Consumer<my_auth.AuthProvider>(
              builder: (context, auth, _) {
                return ElevatedButton(
                  onPressed: _isPhoneValid && !auth.isLoading
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            String phoneNumber = '+20${_phoneController.text}';
                            await auth.sendOtp(context, phoneNumber);
                          }
                        }
                      : null,

                  child: auth.isLoading
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppTextStyles.font16WhiteSemiBold,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
