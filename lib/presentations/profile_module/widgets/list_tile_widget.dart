import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final String iconName;
  final VoidCallback onTap;
  final bool? isComplete;
  final bool? showArrow;
  final Color? fontColor;

  const ListTileWidget({super.key, required this.title, required this.iconName, required this.onTap, this.isComplete, this.showArrow, this.fontColor});

  @override
  Widget build(BuildContext context) {
   return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: CustomSvgIcon(assetName: iconName,width: 20,height: 20,color: AppTheme.isDarkMode()?Colors.white:mainColor,),

            ),
            const SizedBox(width: 24,),
            Expanded(
                child: CustomText(
                  title: title,
                  fontSize: 15,
                  fontColor: fontColor??(AppTheme.isDarkMode() ? Colors.white : Colors.black),
                )),
            const SizedBox(width: 16,),
            Row(
              children: [
                if(isComplete!=null&&!isComplete!)Container(width: 6,height: 6,decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle),),
                if(isComplete!=null&&!isComplete!)const SizedBox(width: 12,),
                if(showArrow==null)Icon(Icons.arrow_forward_ios_rounded,size: 16,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)
              ],
            )
            ,
          ],
        ),
      ),
    );


    return ListTile(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      selectedColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: CustomSvgIcon(assetName: iconName,width: 20,height: 20,color: AppTheme.isDarkMode()?Colors.white:mainColor,),

      ),
      title: CustomText(title: title,fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
      trailing:  Icon(Icons.arrow_forward_ios_rounded,size: 16,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
      minVerticalPadding: 0,
    );
  }
}
