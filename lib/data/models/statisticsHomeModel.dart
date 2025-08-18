
class StatisticsHomeModel{
final HomeBooking? booking;
final HomeGoals? goals;


const StatisticsHomeModel(this.booking, this.goals);

factory StatisticsHomeModel.fromJson(Map<String,dynamic> json){
  return StatisticsHomeModel(json['booking']!=null?HomeBooking.fromJson(json['booking']):null, json['goals']!=null?HomeGoals.fromJson(json['goals']):null);
}

}

class HomeBooking {
  final num? newCount;
  final num? end;

  const HomeBooking(this.newCount, this.end);

  factory HomeBooking.fromJson(Map<String,dynamic> json){
    return HomeBooking(json['new'], json['end']);
  }

}

class HomeGoals {
  final num? percent;
  final num? total;

  const HomeGoals(this.percent, this.total);

  factory HomeGoals.fromJson(Map<String,dynamic> json){
    return HomeGoals(json['percent'], json['total']);
  }

}