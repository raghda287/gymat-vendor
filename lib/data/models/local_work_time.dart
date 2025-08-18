import 'package:equatable/equatable.dart';

class LocalWorkTime extends Equatable {
  final int daySort;
  final String dayTitle;
  final String day;
  final String fromTime;
  final String toTime;

  const LocalWorkTime(this.daySort,this.dayTitle, this.day, this.fromTime, this.toTime);

  Map<String, dynamic> toJson() {
    return {
      'day':day,
      'from_time':fromTime,
      'to_time':toTime,

    };
  }

  @override
// TODO: implement props
  List<Object?> get props => [daySort,day, fromTime, toTime];
}
