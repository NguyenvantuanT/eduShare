import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class AppTextFieldPassword extends StatefulWidget {
  const AppTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.prefixIcon,
    this.readOnly = false,
    this.labelText,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  State<AppTextFieldPassword> createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextFormField(
      cursorColor: AppColor.textColor,
      readOnly: widget.readOnly,
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: !showPassword,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
        filled: true,
        fillColor: AppColor.white,
        border: outlineInputBorder(AppColor.grey),
        focusedBorder: outlineInputBorder(AppColor.grey),
        enabledBorder: outlineInputBorder(AppColor.grey),
        hintText: widget.hintText,
        hintStyle: AppStyles.STYLE_14.copyWith(color: AppColor.grey),
        labelText: widget.labelText,
        labelStyle: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
        prefixIcon: widget.prefixIcon,
        suffixIcon: GestureDetector(
            onTap: () => setState(() => showPassword = !showPassword),
            child: Icon(showPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColor.grey)),
        errorStyle: const TextStyle(color: AppColor.red),
      ),
    );
  }
}
