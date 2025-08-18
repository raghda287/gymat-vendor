class NotificationSetting {

  final bool? is_notification;
  final bool? is_message;
  final bool? bookable;

  NotificationSetting(this.is_notification, this.is_message, this.bookable);

  factory NotificationSetting.fromJson(Map<String,dynamic> json){
    return NotificationSetting(json['is_notification'], json['is_message'],json['bookable']);
  }
}