import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';
import 'package:grocery_app/features/onboarding/presentation/onboarding_data.dart';
import 'package:grocery_app/features/onboarding/widgets/already_have_an_account_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _selectedPage = 0;

  int get _totalPages => onboardingPagesContent.length;
  bool get isLastPage => _selectedPage == _totalPages - 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLastPage() {
    if (_controller.hasClients) {
      _controller.animateToPage(
        _totalPages - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildPageView(),

            // Skip Button
            if (!isLastPage)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: TextButton(
                  onPressed: _goToLastPage,
                  child: Text('Skip', style: AppTextStyles.font16GraySemiBold),
                ),
              ),

            // Dots Indicator
            Positioned(
              bottom: 120.h,
              left: 0,
              right: 0,
              child: DotsIndicator(
                dotsCount: _totalPages,
                position: _selectedPage.toDouble(),
                decorator: DotsDecorator(
                  color: ColorsManager.lightgray,
                  activeColor: ColorsManager.green,
                  size: Size(23.w, 8.h),
                  activeSize: Size(23.w, 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // Bottom Button
            if (isLastPage)
              Positioned(
                bottom: 50.h,
                left: 20.w,
                right: 20.w,
                child: _buildMainButton(),
              ),

            // Already have account
            if (isLastPage)
              Positioned(
                bottom: 5.h,
                left: 0,
                right: 0,
                child: const Center(child: AlreadyHaveAnAccountText()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _controller,
      itemCount: _totalPages,
      onPageChanged: (page) {
        setState(() => _selectedPage = page);
      },
      itemBuilder: (context, index) {
        final pageContent = onboardingPagesContent[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                child: Image.asset(pageContent['image']!),
              ),
              verticalSpace(10),
              Text(pageContent['title']!, style: AppTextStyles.font24BlackBold),
              verticalSpace(15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  pageContent['subtitle']!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16GraySemiBold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to next screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.green,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Set Delivery Location',
        style: AppTextStyles.font16BlackSemiBold,
      ),
    );
  }
}
