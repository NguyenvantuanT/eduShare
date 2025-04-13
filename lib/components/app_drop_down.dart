import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDropDown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final void Function(T?) onChanged;
  final Widget Function(T) itemBuilder;
  final String placeholderText;
  final bool isValid;
  final String? errorText;
  final EdgeInsetsGeometry? paddingMenu;
  final double? maxHeight;

  const AppDropDown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemBuilder,
    this.placeholderText = '',
    this.isValid = true,
    this.paddingMenu,
    this.errorText,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: selectedItem,
            hint: Text(
              placeholderText,
              style: AppStyles.STYLE_16
                  .copyWith(color: AppColor.greyText, fontWeight: FontWeight.w400),
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: itemBuilder(item),
              );
            }).toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isValid ? AppColor.grey : AppColor.red,
                  width: 1,
                ),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: SvgPicture.asset(
                AppImages.icArrowDown,
                height: 8,
                width: 15,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: maxHeight ?? 200,
              width: 132,
              offset: const Offset(180, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: paddingMenu ?? const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              
            ),
          ),
        ),
        if (!isValid) ...[
          const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              errorText ?? "",
              style: AppStyles.STYLE_12.copyWith(color: AppColor.red),
            ),
          ),
        ],
      ],
    );
  }
}
