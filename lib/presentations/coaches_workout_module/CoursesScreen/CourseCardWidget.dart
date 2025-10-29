import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/data/models/course_response.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/app_theme/theme.dart';

class CourseCardWidget extends StatelessWidget{
  double width;
  CourseData courseData;
  VoidCallback deleteCourse;
  CourseCardWidget({super.key,required this.width,required this.courseData,required this.deleteCourse});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
          gradient:LinearGradient(
            // colors: [Color(0xFFa8e09f), Color(0xFF77CC55)],
            colors: AppTheme.isDarkMode()?[mainColor,mainColor]:[startColor,mainColor],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          )
      ),
      child:  Center(
        child: Row(
          children: [
            SvgPicture.asset('assets/images/svg/play_icon.svg',color: Colors.white,width: 25,height: 25),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(title: courseData.title,fontSize: 18,fontColor: Colors.white,fontWeight: FontWeight.bold,),
                CustomText(title: courseData.description,fontSize: 15,fontColor: Colors.white,fontWeight: FontWeight.bold,)
              ],
            )),
            InkWell(
              child: const Icon(Icons.delete_forever,size: 25,color: Colors.white,),
              onTap: deleteCourse,
            )
          ],
        ),
      ),
    );
  }

}