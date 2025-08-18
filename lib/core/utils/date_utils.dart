import 'package:easy_localization/easy_localization.dart';

class DateUtil{

  static DateTime currentDate(){
    return DateTime.now();
  }

  static DateTime parseStringToDate(String date,format){
    DateFormat dateFormat = DateFormat(format,'en');
    return dateFormat.parse(date);
  }

  static String parseDateToString(DateTime dateTime,String format){
    DateFormat dateFormat = DateFormat('yyyy-MM-dd','en');
    return dateFormat.format(dateTime);
  }

}