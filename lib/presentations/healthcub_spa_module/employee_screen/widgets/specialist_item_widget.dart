import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/specialist_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class SpecialistItem extends StatelessWidget {
  final Specialist specialist;
  final bool? enableDarkMode;
  const SpecialistItem({super.key, required this.specialist, this.enableDarkMode});

  @override
  Widget build(BuildContext context) {
    print("sdasdasds=>${specialist.name??''}");
    return Column(children: [
      CustomAvatar(url: specialist.image,radius: 56,borderColor:enableDarkMode==null? AppTheme.isDarkMode()?Colors.white:mainColor:mainColor,placeHolderColor: AppTheme.isDarkMode()?inputBgDark:inputBg,borderWidth: 1,),
      const SizedBox(height: 4,),
      CustomText(title: specialist.name??'',fontColor: enableDarkMode==null?AppTheme.isDarkMode()?Colors.white:Colors.black:Colors.black,fontSize: 15,fontWeight: FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
      const SizedBox(height: 4,),
      enableDarkMode==null?CustomText(title: getDepartments(),fontColor: greyColor,fontSize: 12,textAlign: TextAlign.center,maxLines: 2,):const SizedBox(),
      SizedBox(height:  enableDarkMode==null?4:0,),

    ],);
  }
  String getDepartments(){
    return specialist.categories.map((e) => e.getTitle()).join(',');
  }
}
