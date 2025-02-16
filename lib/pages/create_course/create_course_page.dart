
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/create_course/create_course_vm.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class CreateCoursePage extends StackedView<CreateCourseVM> {
  const CreateCoursePage({super.key});

  @override
  CreateCourseVM viewModelBuilder(BuildContext context) => CreateCourseVM();
  
  @override
  Widget builder(BuildContext context, CreateCourseVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        padding: EdgeInsets.zero,
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
              key: viewModel.formKey,
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
                    controller: viewModel.nameCourseController,
                    labelText: "e.g., how to ...",
                    textInputAction: TextInputAction.next,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Name Category?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    readOnly: true,
                    onTap: viewModel.showBotMenu,
                    controller: viewModel.categoryController,
                    hintText: "e.g., biology",
                    hintTextColor: AppColor.textColor,
                    textInputAction: TextInputAction.next,
                    validator: Validator.required,
                  ),
                  if (viewModel.showMenu)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.bgColor,
                        boxShadow: AppShadow.boxShadowContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children:
                            List.generate(CategoryType.values.length, (idx) {
                          final category = CategoryType.values[idx];
                          return InkWell(
                              onTap: () => viewModel.pickCategory(category),
                              child: Container(
                                height: 30.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:
                                        viewModel.categoryController.text == category.name
                                            ? AppColor.blue
                                            : null),
                                child: Text(
                                  category.name,
                                  style: AppStyles.STYLE_14.copyWith(
                                      color: viewModel.categoryController.text ==
                                              category.name
                                          ? AppColor.bgColor
                                          : AppColor.textColor),
                                ),
                              ));
                        }),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Description ?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextFieldDes(viewModel),
                  const SizedBox(height: 10.0),
                  _buildSelectImage(viewModel),
                  const SizedBox(height: 50.0),
                  AppElevatedButton(
                    isDisable: viewModel.isLoading,
                    text: 'Make Course',
                    onPressed: () => viewModel.addCourse(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  
  TextField _buildTextFieldDes(CreateCourseVM viewModel) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      controller: viewModel.describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          hintText: 'e.g., describe',
          hintStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  Widget _buildSelectImage(CreateCourseVM viewModel) {
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
                border: Border.all(color: AppColor.blue),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: viewModel.imageCourse == null
                      ? Image.asset(AppImages.imageLogoPng).image
                      : FileImage(viewModel.imageCourse!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: viewModel.pickImageCourse,
              child: Container(
                  height: 60.0,
                  width: 60.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColor.greyText, width: 1.2),
                    color: AppColor.white,
                  ),
                  child: SvgPicture.asset(AppImages.iconCamera)),
            ),
          ],
        ),
      ],
    );
  }
  
}

