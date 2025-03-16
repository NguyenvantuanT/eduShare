import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/onboarding_model.dart';
import 'package:chat_app/pages/onBoarding/on_boarding_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class OnBoardingPage extends StackedView<OnBoardingVm> {
  const OnBoardingPage({super.key});

  @override
  OnBoardingVm viewModelBuilder(BuildContext context) => OnBoardingVm();

  @override
  void onViewModelReady(OnBoardingVm viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, OnBoardingVm viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
          top: MediaQuery.of(context).padding.top + 50.0,
          bottom: 50.0,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 240.0,
              child: PageView(
                controller: viewModel.pageController,
                onPageChanged: viewModel.changePage,
                children: List.generate(
                  onboardings.length,
                  (idx) => SvgPicture.asset(onboardings[idx].imagePath ?? "",
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Container(
              height: 80.0,
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                onboardings[viewModel.currentIndex].text ?? "",
                textAlign: TextAlign.center,
                style: AppStyles.STYLE_14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardings.length, (idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: idx == viewModel.currentIndex ? 30.0 : 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                        color: idx == viewModel.currentIndex
                            ? AppColor.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                );
              }),
            ),
            const Spacer(),
            AppElevatedButton(
                text: viewModel.currentIndex == onboardings.length - 1
                    ? 'Start'
                    : 'Next',
                onPressed: () => viewModel.onPressed(context))
          ],
        ),
      ),
    );
  }
}
