import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/department_model.dart';

class DropDownWidget extends StatelessWidget {
  final List<DepartmentModel> items;
  final int? selectedItem;
  final Function(int?) onChanged;
  final String hintText;

  const DropDownWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<int>(
        value: selectedItem,
        onChanged: onChanged,
        hint: Text(hintText),
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map<DropdownMenuItem<int>>((DepartmentModel value) {
          return DropdownMenuItem<int>(
            value: value.id as int?,
            child: Text(value.getTitle()),
          );
        }).toList(),
      ),
    );
  }
}
