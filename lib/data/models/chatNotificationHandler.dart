
class ChatNotificationHandler{
  final num? roomId;
  bool? showNotification;

  ChatNotificationHandler(this.roomId, this.showNotification);

  Map<String,dynamic> toJson(){
    return {
      'roomId':roomId,
      'showNotification':showNotification
    };
  }

  factory ChatNotificationHandler.fromJson(Map<String,dynamic> json){
    return ChatNotificationHandler(json['roomId'], json['showNotification']);
  }
}