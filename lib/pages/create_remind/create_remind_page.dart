import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/create_remind/create_remind_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateRemindPage extends StackedView<CreateRemindVM> {
  const CreateRemindPage({super.key, this.title, this.timeSt});

  final String? title;
  final String? timeSt;

  @override
  void onViewModelReady(CreateRemindVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  CreateRemindVM viewModelBuilder(BuildContext context) => CreateRemindVM(
        title: title,
        timeSt: timeSt,
      );

  @override
  Widget builder(
      BuildContext context, CreateRemindVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: "Add Remind"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          Row(
            children: [
              Text(
                'Title',
                style:
                    AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => viewModel.shareViaEmail(context),
                icon: const Icon(
                  Icons.email,
                  color: AppColor.blue,
                ),
              ),
              IconButton(
                onPressed: () => viewModel.shareToFacebook(context),
                icon: const Icon(
                  Icons.share,
                  color: AppColor.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: viewModel.titleController,
            labelText: "Enter your title",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Note',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: viewModel.noteController,
            labelText: "Enter your note",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
            maxLines: 5,
          ),
          const SizedBox(height: 20.0),
          if (title != null) ...[
            Text(
              'Time',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              readOnly: true,
              controller: viewModel.timeController,
              labelText: "Select time",
              validator: Validator.required,
              onTap: () => viewModel.pickTime(context),
            ),
            const SizedBox(height: 20.0),
          ],
          Text(
            'Color',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            children: List.generate(
              3,
              (idx) => GestureDetector(
                onTap: () => viewModel.changeColor(idx),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: viewModel.colors[idx],
                    child: viewModel.selectColor == idx
                        ? const Icon(
                            Icons.done,
                            size: 16.0,
                            color: AppColor.white,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.45,
            child: AppElevatedButton(
              text: "Create Todo",
              isDisable: viewModel.isLoad,
              onPressed: () => viewModel.createTodo(context),
            ),
          ),
        ],
      ),
    );
  }
}
