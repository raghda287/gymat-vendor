import 'package:gymatvendor/data/models/fitnessModel.dart';
import 'package:gymatvendor/data/models/generalOrderModel.dart';

class UserProfileModel {
  final User? user;
  final FitnessModel? goals;

  UserProfileModel(this.user, this.goals);

  factory UserProfileModel.fromJson(Map<String,dynamic> json){
    return UserProfileModel(json['user']!=null?User.fromJson(json['user']):null, json['goals']!=null?FitnessModel.fromJson(json['goals']):null);
  }


}