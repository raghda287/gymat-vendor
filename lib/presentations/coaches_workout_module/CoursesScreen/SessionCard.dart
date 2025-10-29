
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/course_details_response.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class SessionCard extends StatelessWidget{
  Session session;
  double width,borderRadius;
  VoidCallback deleteSession ;
  SessionCard({super.key,required this.session,required this.width,required this.borderRadius,required this.deleteSession});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        color: AppTheme.isDarkMode()?dark:Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: mainColor,
                  ),
                  child: CustomText(title: session.type=="live"?"Live".tr():"recorded".tr(),
                      fontSize: 15,fontColor: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFe6eaf4),
                  ),
                  child: CustomText(title: session.isFree==true?"Free".tr():"Payed".tr(),
                      fontSize: 15,fontColor: mainColor),
                ),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(title: session.title,fontSize: 20,fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                      fontWeight: FontWeight.bold,),
                    CustomText(title: session.description,fontSize: 15,fontColor: Colors.grey,
                      fontWeight: FontWeight.bold,)
                  ],
                ),


                SvgPicture.asset('assets/images/svg/play_icon.svg',color: mainColor,width: 50,height: 50)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.red
                  ),
                  child: IconButton(onPressed: deleteSession, icon: const Icon(Icons.delete_forever,color: Colors.white,size: 25,)),
                )
              ],
            )
          ],
        ),),
      ),
    );
  }

}