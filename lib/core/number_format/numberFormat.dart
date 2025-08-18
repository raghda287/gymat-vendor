
import 'package:easy_localization/easy_localization.dart';

class CustomNumberFormat{
  static String  format(num number,[int? decimalPoint]){
    if(number==0){
      return '0.0';
    }else{
      return number.toStringAsFixed(decimalPoint??2);
    }

  }

  static String formatRate(num number){
    if(number==0){
      return '0';
    }else{
      return NumberFormat('#.0#','en_US').format(number);
    }

  }
  static String durationFormat(int seconds){

    String time = '';
    Duration duration = Duration(seconds: seconds);
    String second = '00';
    String min = '00';
    String hours = '00';

    if(duration.inSeconds<10){
      second = '0${duration.inSeconds}';
    }else{
      second = '${duration.inSeconds}';
    }

    if(duration.inMinutes<10){
      min = '0${duration.inMinutes}';
    }else{
      min = '${duration.inMinutes}';
    }

    if(duration.inHours<10){
      min = '0${duration.inHours}';
    }else{
      min = '${duration.inHours}';
    }

    if(hours!='00'){
      time = '$hours:$min:$second';
    }else{
      time = '$min:$second';

    }

    return time;

  }

  static String getPeopleCountFormat(num people){
    if(people<1000){
      return '$people';
    }else if(people<1000000){
      int p = people ~/1000;
      return '$p ${'k'.tr()}';
    }else{
      int p = people ~/1000000;
      return '$p ${'m'.tr()}';
    }
  }
}