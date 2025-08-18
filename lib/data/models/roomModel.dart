import 'package:gymatvendor/data/models/user_model.dart';
import 'generalOrderModel.dart';
import 'messageModel.dart';
class RoomModel {
  final num? id;
  final num? market_id;
  final num? user_id;
  final AccountsModel? market;
  final ChatUser? user;
  MessageModel? latest_message;
  final List<MessageModel> messages;

  RoomModel(this.id, this.market_id, this.user_id, this.market, this.user, this.latest_message, this.messages);

  factory RoomModel.fromJson(Map<String,dynamic> json){
    List<MessageModel> list = [];
    if(json['messages']!=null){
      json['messages'].forEach((v)=>list.add(MessageModel.fromJson(v)));
    }
    return RoomModel(json['id'],json['market_id'] ,json['user_id'] ,json['market']!=null?AccountsModel.fromJson(json['market']): null,json['user']!=null?ChatUser.fromJson(json['user']):null ,json['latest_message']!=null?MessageModel.fromJson(json['latest_message']):null ,list);
  }


  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'market_id':market_id,
      'user_id':user_id,
      'market':market?.toJson(),
      'user':user?.toJson(),
      'latest_message':latest_message?.toJson(),

    };
  }
}

class ChatUser {
  final User? user;

  const ChatUser(this.user);

  factory ChatUser.fromJson(Map<String, dynamic> json){
    return ChatUser(json['user'] != null ? User.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson()
    };
  }
}