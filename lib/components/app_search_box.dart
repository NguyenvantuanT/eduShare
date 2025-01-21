import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSearchBox extends StatelessWidget {
  const AppSearchBox({
    super.key,
    this.searchController,
    this.onChanged,
    this.searchFocus,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? searchController;
  final Function(String)? onChanged;
  final FocusNode? searchFocus;
  final bool readOnly;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: color),
        );
    return TextField(
      controller: searchController,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
      focusNode: searchFocus,
      decoration: InputDecoration(
          hintText: "Search your course",
          hintStyle: AppStyles.STYLE_14.copyWith(color: AppColor.greyText),
          border: outlineInputBorder(AppColor.greyText),
          focusedBorder: outlineInputBorder(AppColor.greyText),
          enabledBorder: outlineInputBorder(AppColor.greyText),
          contentPadding: const EdgeInsets.only(top: 14.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 17.0,
              top: 14.0,
              bottom: 13.0,
            ),
            child: SvgPicture.asset(
              AppImages.iconSearch,
              color: AppColor.blue,
              fit: BoxFit.contain,
            ),
          )),
    );
  }
}
