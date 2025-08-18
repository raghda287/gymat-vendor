import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../data/models/day_unit_type.dart';
import '../custom_bordered_container/custom_bordered_container.dart';
import '../custom_text/custom_text.dart';

class DropDownDays extends StatefulWidget {
  final List<DayUnitType> list;
  final ValueChanged onValueSelected;
  final DayUnitType? defalutValue;
  const DropDownDays({super.key, required this.list, required this.onValueSelected, this.defalutValue});

  @override
  State<DropDownDays> createState() => _DropDownDaysState();
}

class _DropDownDaysState extends State<DropDownDays> {
  DayUnitType? model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.defalutValue!=null){
      model = widget.defalutValue;

    }else{
      model = widget.list.first;

    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBorderedContainer(
      width: 140,
      borderColor: Colors.transparent,
      bg: AppTheme.isDarkMode() ? inputBgDark : inputBg,
      height: 54,
      borderRadius: 16,
      child: DropdownButton<DayUnitType>(
          value: model,
          items: widget.list
              .map((e) => DropdownMenuItem<DayUnitType>(
              value: e,
              child: CustomText(
                title: e.title ?? '',
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
            model = value;
            widget.onValueSelected(value!.value);
            setState(() {});
          }),
    );
  }
}
