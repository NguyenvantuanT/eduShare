import 'package:chat_app/models/remind_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class RemindCard extends StatelessWidget {
  const RemindCard(
    this.todoModel, {
    super.key,
    this.onCompleted,
    this.onTap,
  });

  final RemindModel todoModel;
  final Function()? onCompleted;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [AppColor.blue, AppColor.pink, AppColor.orange];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colors[todoModel.color ?? 0],
            borderRadius: const BorderRadius.all(Radius.circular(16.0))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    todoModel.title ?? "||",
                    style: AppStyles.STYLE_14.copyWith(color: AppColor.bgColor),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: AppColor.bgColor, size: 18.00),
                      const SizedBox(width: 5.0),
                      Text(
                        todoModel.dateCreate ?? "||",
                        style: AppStyles.STYLE_12
                            .copyWith(color: AppColor.bgColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    todoModel.note ?? "||",
                    style: AppStyles.STYLE_14.copyWith(color: AppColor.bgColor),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColor.bgColor,
              height: 60.0,
              width: 0.5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            GestureDetector(
              onTap: onCompleted,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  todoModel.isCompleted ?? false ? "COMPLETED" : "TODO",
                  style: todoModel.isCompleted ?? false
                      ? AppStyles.STYLE_10.copyWith(color: AppColor.bgColor)
                      : AppStyles.STYLE_12.copyWith(color: AppColor.bgColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
