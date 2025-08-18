
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomDateTimeFormat{

  String convertTimeOfDayToAmPm(TimeOfDay timeOfDay){
    DateTime now = DateTime.now();
    DateTime time = DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute,0,0,0);
    String t = DateFormat('hh:mm a','en').format(time);
    return t;
  }

  String getNowDate(){
    DateTime now = DateTime.now();
    String t = DateFormat('yyyy-MM-dd','en').format(now);
    return t;
  }

  String convertDateToCustomFormat(String date,String format){

    DateFormat dateFormat = DateFormat('yyyy-MM-dd','en');
    DateTime dateTime = dateFormat.parse(date);
    return DateFormat(format,'en').format(dateTime);

  }

  String timeAgo(String? date,String? time){
    if(date!=null&&date.isNotEmpty&&time!=null&&time.isNotEmpty){
      int secondInMill = 1000;
      int minuteInMill = 60*secondInMill;
      int hourInMill = 60*minuteInMill;
      int dayInMill = 24*hourInMill;
      DateTime now = DateTime.now();
      DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a','en').parse('$date $time');

      if(dateTime.millisecondsSinceEpoch>now.millisecondsSinceEpoch){
        return '';
      }

      int diff = now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

      if(diff<minuteInMill){
        return'just now'.tr();
      }else if(diff<hourInMill){
        int min = diff~/minuteInMill;
        String m='min'.tr();
        return '$min$m';
      }else if(diff<dayInMill){
        int hr = diff~/hourInMill;
        String h='h'.tr();

        return '$hr$h';
      }else{
        int day = diff~/dayInMill;
        String d='d'.tr();

        return '$day$d';
      }
    }

    return'';

  }
}