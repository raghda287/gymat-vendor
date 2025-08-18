import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/app_colors/app_colors.dart';
import '../../../../../core/app_theme/theme.dart';
import '../../../../../core/text_styles/text_styles.dart';
import '../../../../data/models/user_model.dart';


class AppCalender extends StatefulWidget {
  final List<WorkTime> workTimeList;
  final Function onDateSelected;
  final DateTime? initDateTime;

  const AppCalender({super.key,required this.onDateSelected, required this.workTimeList, this.initDateTime});

  @override
  State<AppCalender> createState() => _AppCalenderState();
}

class _AppCalenderState extends State<AppCalender> {
  late DateTime dateTime;
  late DateTime firstDateTime;
  late CalendarFormat calendarFormat;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
    firstDateTime = DateTime.now();

    if(widget.initDateTime!=null){
      dateTime = widget.initDateTime!;
      if(dateTime.isBefore(firstDateTime)){
        firstDateTime = dateTime;
      }
    }

    calendarFormat = CalendarFormat.twoWeeks;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: AppTheme.isDarkMode() ? dark : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
      child: TableCalendar(
        focusedDay: dateTime,
        firstDay: firstDateTime,
        currentDay: DateTime.now(),
        lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        locale: 'en_US',

        startingDayOfWeek: StartingDayOfWeek.saturday,
        weekNumbersVisible: false,
        calendarFormat: calendarFormat,

        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: AppTextStyles()
                .normalText(fontSize: 13)
                .textColorNormal(greyColor),
            weekendStyle: AppTextStyles()
                .normalText(fontSize: 13)
                .textColorNormal(greyColor)),

        calendarStyle: CalendarStyle(
          todayTextStyle: AppTextStyles()
              .normalText()
              .textColorNormal(mainColor),
          todayDecoration: const BoxDecoration(),
          selectedTextStyle: AppTextStyles().normalText().textColorNormal(Colors.white),
          selectedDecoration: const BoxDecoration(color: mainColor,shape: BoxShape.circle),
          weekendTextStyle: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
          disabledTextStyle: AppTextStyles()
              .normalText()
              .textColorNormal(greyColor.withOpacity(.7)),
          defaultTextStyle: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
          outsideTextStyle: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        ),
        enabledDayPredicate: widget.workTimeList.isNotEmpty? (dateTime){
          String week = '';
          if(dateTime.weekday==DateTime.saturday){
            week = 'SAT';
          }else if(dateTime.weekday==DateTime.sunday){
            week = 'SUN';

          }else if(dateTime.weekday==DateTime.monday){
            week = 'MON';

          }else if(dateTime.weekday==DateTime.tuesday){
            week = 'TUE';

          }else if(dateTime.weekday==DateTime.wednesday){
            week = 'WED';

          }else if(dateTime.weekday==DateTime.thursday){
            week = 'THU';

          }else{
            week = 'FRI';

          }
          if(widget.workTimeList.isEmpty){
            return dateTime.weekday==DateTime.saturday||
                dateTime.weekday==DateTime.sunday||
                dateTime.weekday==DateTime.monday||
                dateTime.weekday==DateTime.tuesday||
                dateTime.weekday==DateTime.wednesday||
                dateTime.weekday==DateTime.thursday||
                dateTime.weekday==DateTime.friday;

            return true;
          }
          return isDayInWorksDays(week);


        }:null,
        selectedDayPredicate: (day){
          return isSameDay(dateTime, day);
        },
        onDisabledDayTapped: (dateTime){
          return ;
        },
        onDaySelected: (selectedDay,focusedDay){
          dateTime = selectedDay;
          widget.onDateSelected(dateTime);
          setState(() {

          });


        },
        onFormatChanged: (format){

          calendarFormat = format;
          setState(() {

          });
        },
      ),
    );
  }

  bool isDayInWorksDays(String day){
    for(WorkTime workTime in widget.workTimeList){
      if(workTime.day==day){
        return true;
      }
    }
    return false;
  }
}
