import 'package:chat_app/components/app_modal.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/pages/create_remind/create_remind_page.dart';
import 'package:chat_app/pages/remind/remind_vm.dart';
import 'package:chat_app/pages/remind/widgets/remind_card.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class RemindPage extends StackedView<RemindVM> {
  const RemindPage({super.key});

  @override
  RemindVM viewModelBuilder(BuildContext context) => RemindVM();

  @override
  void onViewModelReady(RemindVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, RemindVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildAddTodo(context, viewModel),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0).copyWith(left: 16.0),
            child: DatePicker(
              viewModel.now,
              height: 90.0,
              width: 60.0,
              initialSelectedDate: viewModel.now,
              selectionColor: AppColor.blue,
              selectedTextColor: AppColor.bgColor,
              dateTextStyle:
                  AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
              monthTextStyle:
                  AppStyles.STYLE_12.copyWith(color: AppColor.textColor),
              onDateChange: (date) => viewModel.getTodosByDate(date)
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: viewModel.todos.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 20.0),
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (context, idx) {
                final todo = viewModel.todos[idx];
                return AnimationConfiguration.staggeredList(
                  position: idx,
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 500),
                    horizontalOffset: 200.0,
                    child: FadeInAnimation(
                      child: RemindCard(
                        todo,
                        onTap: () {
                          AppModal.todoModal(
                            context,
                            onDelete: () => viewModel.deleteTodo(todo.todoId ?? ""),
                            onComplete: () => viewModel.updateTodo(todo),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddTodo(BuildContext context, RemindVM viewModel) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppStyles.STYLE_14_BOLD.copyWith(
                  color: AppColor.textColor,
                ),
              ),
              Text(
                "Today",
                style: AppStyles.STYLE_14_BOLD.copyWith(
                  color: AppColor.textColor,
                ),
              )
            ],
          ),
        ),
        AppElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  CreateRemindPage(
                timeSt: "${viewModel.selectDate.year}-${viewModel.selectDate.month}-${viewModel.selectDate.day}",
              ),
            ),
          ),
          height: 40,
          icon: const Icon(
            Icons.add,
            color: AppColor.white,
            size: 12.0,
          ),
          text: "Add Remind",
        )
      ],
    );
  }
}

