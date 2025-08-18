class NotificationModel{
  final num? id;
  final num? market_id;
  final num? user_id;
  final String? title;
  final String? body;
  final String? date;
  final String? time;
  final NotificationData? data;

  NotificationModel(this.id, this.market_id, this.user_id, this.title,
      this.body, this.date, this.time, this.data);
  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(json['id'],json['market_id'] ,json['user_id'] ,json['title'] ,json['body'] ,json['date'] ,json['time'] ,json['data']!=null?NotificationData.fromJson(json['data']):null );
  }
}

class NotificationData {
  final String? noti_type;
  final String? order_id;
  final String? live_session_id;
  final String? market_id;
  final String? category_id;
  final String? category_title;

  NotificationData(this.noti_type, this.order_id, this.market_id, this.category_id, this.category_title, this.live_session_id);

  factory NotificationData.fromJson(Map<String,dynamic> json){
    return NotificationData(json['noti_type'],json['order_id'] ,json['market_id'] ,json['category_id'] ,json['category_title'],json['live_session_id']);
  }
}