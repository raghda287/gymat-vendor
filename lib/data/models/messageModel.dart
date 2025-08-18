
class MessageModel {
  final num? id;
  final num? room_id;
  final num? user_id;
  final num? market_id;
  final String? message;
  final String? file;
  final String? type;
  final String? sender;
  final String? date;
  final String? time;
  final int? seconds;
  final num? dimensions;
  final num? timestamp;

  MessageModel(this.id, this.room_id, this.message, this.file, this.type,
      this.sender, this.date, this.time, this.seconds, this.dimensions, this.timestamp,this.user_id,this.market_id);

  factory MessageModel.fromJson(Map<String,dynamic> json){
    return MessageModel(json['id'],json['room_id'] ,json['message'] ,json['file'] ,json['type'] ,json['sender'] ,json['date'] ,json['time'],json['seconds'],json['dimensions'],json['timestamp'],json['user_id'],json['market_id']);
  }


  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'room_id':room_id,
      'message':message,
      'file':file,
      'type':type,
      'sender':sender,
      'date':date,
      'time':time,
      'seconds':seconds,
      'dimensions':dimensions,
      'timestamp':timestamp,
      'user_id':user_id,
      'market_id':market_id,

    };
  }

}