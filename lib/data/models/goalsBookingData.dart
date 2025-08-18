
class GoalsBookingData {
  final Goal? goal;
  final Booking? booking;

  const GoalsBookingData(this.goal, this.booking);

  factory GoalsBookingData.fromJson(Map<String,dynamic> json){
    return GoalsBookingData(json['goals']!=null?Goal.fromJson(json['goals']):null, json['booking']!=null?Booking.fromJson(json['booking']):null);

  }
}

class Goal {
  final Data? today;
  final Data? month;
  final Data? year;

  const Goal(this.today, this.month, this.year);

  factory Goal.fromJson(Map<String,dynamic> json){
    return Goal(json['today']!=null?Data.fromJson(json['today']):null, json['month']!=null?Data.fromJson(json['month']):null, json['year']!=null?Data.fromJson(json['year']):null);
  }
}

class Data{
  final num? percent;
  final num? value;

  const Data(this.percent, this.value);
  factory Data.fromJson(Map<String,dynamic> json){
    return Data(json['percent'], json['value']);
  }
}

class Booking{
  final num? today;
  final num? this_month;
  final num? last_month;

  const Booking(this.today, this.this_month, this.last_month);

  factory Booking.fromJson(Map<String,dynamic> json){
    return Booking(json['today'], json['this_month'],json['last_month']);

  }
}