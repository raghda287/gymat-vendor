import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/specialist_model.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../widgets/custom_bordered_container/custom_bordered_container.dart';
import '../../../widgets/custom_text/custom_text.dart';


class DropDownSpecialistWidget extends StatefulWidget {
  final List<Specialist> list;
  final ValueChanged<Specialist> onValueSelected;
  final Specialist? defaultValue;
  final bool isLoading;
  const DropDownSpecialistWidget({super.key, required this.list, required this.onValueSelected, this.defaultValue, required this.isLoading});

  @override
  State<DropDownSpecialistWidget> createState() =>
      _DropDownSpecialistWidgetState();
}

class _DropDownSpecialistWidgetState extends State<DropDownSpecialistWidget> {
  Specialist? model;

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
      child: DropdownButton<Specialist>(
          value: model,
          hint: widget.isLoading?CustomText(title: 'Loading....'.tr(),fontColor: greyColor,fontSize: 13,):const SizedBox(),
          items: widget.list
              .map((e) => DropdownMenuItem<Specialist>(
                  value: e,
                  child: CustomText(
                    title: e.name??'',
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
            widget.onValueSelected(value!);
            setState(() {});

          }),
    );
  }
}
