import 'package:gymatvendor/data/models/generalOrderModel.dart';

class FollowerModel{
 final User? user;

 const FollowerModel(this.user);

 factory FollowerModel.fromJson(Map<String,dynamic> json){
   return FollowerModel(json['user']!=null?User.fromJson(json['user']):null);
 }
}