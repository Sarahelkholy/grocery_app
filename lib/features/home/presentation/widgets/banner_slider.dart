import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/theming/colors.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int currentImageIndex = 0;
  int dataLength = 1;

  @override
  initState() {
    getBannerImages();
    super.initState();
  }

  Future getBannerImages() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('slider').get();
    setState(() {
      dataLength = snapshot.docs.length;
    });
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dataLength != 0)
          FutureBuilder(
            future: getBannerImages(),
            builder: (_, snapShot) {
              return snapShot.data == null
                  ? CircularProgressIndicator()
                  : CarouselSlider.builder(
                      options: CarouselOptions(
                        aspectRatio: 14 / 6.5,
                        viewportFraction: .85,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        scrollPhysics: BouncingScrollPhysics(),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentImageIndex = index;
                          });
                        },
                      ),
                      itemCount: snapShot.data!.length,
                      itemBuilder: (context, index, _) {
                        DocumentSnapshot banner = snapShot.data![index];
                        Map getImage = banner.data() as Map;
                        return SizedBox(
                          height: 150.h,
                          width: double.infinity,
                          child: Image.network(
                            getImage['image'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
            },
          ),

        verticalSpace(10),
        DotsIndicator(
          dotsCount: dataLength,
          position: currentImageIndex.toDouble(),
          decorator: DotsDecorator(
            color: ColorsManager.lightgray,
            activeColor: ColorsManager.green,
            size: Size(12.w, 8.h),
            activeSize: Size(12.w, 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
