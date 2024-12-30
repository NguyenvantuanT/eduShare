import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  AppElevatedButton({
    super.key,
    this.onPressed,
    this.height = 48.0,
    this.color = AppColor.blue,
    this.borderColor = AppColor.blue,
    required this.text,
    this.textColor = AppColor.white,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
        splashColor = splashColor ?? AppColor.grey.withOpacity(0.2),
        highlightColor = highlightColor ?? AppColor.red.withOpacity(0.6);

  AppElevatedButton.small({
    super.key,
    this.onPressed,
    this.height = 38.0,
    this.color = AppColor.blue,
    this.borderColor = AppColor.blue,
    required this.text,
    this.textColor = AppColor.white,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
        splashColor = splashColor ?? AppColor.grey.withOpacity(0.2),
        highlightColor = highlightColor ?? AppColor.red.withOpacity(0.6);

  AppElevatedButton.outline({
    super.key,
    this.onPressed,
    this.height = 48.0,
    this.color = AppColor.white,
    this.borderColor = AppColor.grey,
    required this.text,
    this.textColor = AppColor.black,
    this.fontSize = 16.0,
    this.icon,
    BorderRadius? borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.isDisable = false,
    Color? splashColor,
    Color? highlightColor,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(10.0),
        splashColor = splashColor ?? AppColor.blue.withOpacity(0.6),
        highlightColor = highlightColor ?? AppColor.green.withOpacity(0.6);

  
  

  final Function()? onPressed;
  final double height;
  final Color color;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final Icon? icon;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isDisable;
  final Color splashColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: isDisable == true ? null : onPressed,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: Ink(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 1.4),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 4.6),
              ],
              isDisable == true
                  ? Center(
                      child: SizedBox.square(
                        dimension: height - 22.0,
                        child: CircularProgressIndicator(
                            color: textColor, strokeWidth: 2.2),
                      ),
                    )
                  : Text(
                      text,
                      style: AppStyles.STYLE_14.copyWith(color: textColor),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
