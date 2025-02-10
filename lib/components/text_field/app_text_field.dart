import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.labelText,
    this.onChanged, this.onTap,  this.hintTextColor  =  AppColor.grey,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color hintTextColor;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onTap:onTap,
      cursorColor: AppColor.textColor,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      validator: validator,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
        filled: true,
        fillColor: AppColor.white,
        border: outlineInputBorder(AppColor.grey),
        focusedBorder: outlineInputBorder(AppColor.grey),
        enabledBorder: outlineInputBorder(AppColor.grey),
        hintText: hintText,
        hintStyle: AppStyles.STYLE_14.copyWith(color:hintTextColor),
        labelText: labelText,
        labelStyle: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
        prefixIcon: prefixIcon,
        errorStyle: const TextStyle(color: AppColor.red),
      ),
    );
  }
}
