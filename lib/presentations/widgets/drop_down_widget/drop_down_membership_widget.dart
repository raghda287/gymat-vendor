import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../data/models/department_model.dart';
import '../custom_bordered_container/custom_bordered_container.dart';
import '../custom_text/custom_text.dart';

class DropDownMembershipDepartmentWidget extends StatefulWidget {
  final List<DepartmentModel> departments;
  final ValueChanged<DepartmentModel> onValueSelected;
  final DepartmentModel? defaultValue;
  final bool isLoading;
  const DropDownMembershipDepartmentWidget({super.key, required this.departments, required this.onValueSelected, this.defaultValue, required this.isLoading});

  @override
  State<DropDownMembershipDepartmentWidget> createState() =>
      _DropDownMembershipDepartmentWidgetState();
}

class _DropDownMembershipDepartmentWidgetState extends State<DropDownMembershipDepartmentWidget> {
  DepartmentModel? model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBorderedContainer(
      borderColor: Colors.transparent,
      bg: AppTheme.isDarkMode() ? inputBgDark : inputBg,
      height: 54,
      borderRadius: 16,
      child: DropdownButton<DepartmentModel>(
          value: model,
          hint: widget.isLoading?CustomText(title: 'Loading....'.tr(),fontColor: greyColor,fontSize: 13,):const SizedBox(),
          items: widget.departments
              .map((e) => DropdownMenuItem<DepartmentModel>(
                  value: e,
                  child: CustomText(
                    title: e.trans_title!.contains('trans')?e.title??'': e.trans_title??'',
                    fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                  )))
              .toList(),
          elevation: 1,
          iconSize: 24,
          iconEnabledColor: AppTheme.isDarkMode() ? Colors.white : greyColor,
          underline: const SizedBox(),
          borderRadius: BorderRadius.circular(8),
          isExpanded: true,
          dropdownColor: AppTheme.isDarkMode() ? inputBgDark : Colors.white,
          onChanged: (value) {
            if(value!=null&&value.id!=1){
              model = value;

            }
            widget.onValueSelected(value!);
            setState(() {});

          }),
    );
  }
}
