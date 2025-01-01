import 'dart:io';

import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MakeCoursePage extends StatefulWidget {
  const MakeCoursePage({super.key});

  @override
  State<MakeCoursePage> createState() => _MakeCoursePageState();
}

class _MakeCoursePageState extends State<MakeCoursePage> {
  final nameCourseController = TextEditingController();
  File? imageCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 6.0),
          Stack(
            children: [
              SvgPicture.asset(AppImages.imageMakeCourse),
              Positioned(
                left: 30.0,
                right: 30.0,
                bottom: 90.0,
                child: Text(
                  "What do You Want to make today",
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_24.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name Your Course?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: nameCourseController,
                    labelText: "e.g., how to ...",
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Name Category?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: nameCourseController,
                    labelText: "e.g., biology",
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10.0),
                  _buildSelectImage(),
                  const SizedBox(height: 50.0),
                  AppElevatedButton(text: 'Make Course')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images Course?',
          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 64.0,
              width: 64.0,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: imageCourse == null
                      ? Image.asset(AppImages.imageDefault).image
                      : FileImage(imageCourse!),
                  fit: BoxFit.cover,
                ),
              ),
              child: SvgPicture.asset(
                AppImages.iconClosed,
                height: 16.0,
                width: 16.0,
              ),
            ),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: () {},
              child: Container(
                  height: 60.0,
                  width: 60.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColor.greyText, width: 1.2),
                    color: AppColor.white,
                  ),
                  child: const Icon(
                    Icons.camera,
                    color: AppColor.greyText,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
