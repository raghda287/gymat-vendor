import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/local_work_time.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../../injection.dart';

class WorkTimeItem extends StatelessWidget {
  final LocalWorkTime model;
  final int index;
  const WorkTimeItem({super.key,required this.model,required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: CustomText(title: '${model.dayTitle??''}  ${'FROM'.tr()} ${model.fromTime}  ${'TO'.tr()} ${model.toTime}',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
            IconButton(onPressed: (){
              AuthProvider provider =getIt();
              provider.deleteWorkTime(index);
            }, icon: Icon(Icons.close,color: AppTheme.isDarkMode()?Colors.white:Colors.black,size: 20,))
          ],
        ),
      ),
    );
  }
}
