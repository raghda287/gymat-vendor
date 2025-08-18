
import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/user_model.dart';

class GeneralOrderModel {
 final num? id;
 final num? total;
 final num? tax;
 final num? discount;
 final num? grand_total;
 final bool? is_paid;
 final AccountsModel? market;
 final OrderUser? user;
 final String? date;
 final String? time;
 final String? status;

 bool isExpanded = false;


 GeneralOrderModel(this.id, this.total, this.tax, this.grand_total, this.is_paid, this.market, this.user, this.date, this.time, this.status, this.discount);

 factory GeneralOrderModel.fromJson(Map<String,dynamic> json){
   return GeneralOrderModel(json['id'],json['total'] ,json['tax'] ,json['grand_total'] ,json['is_paid'] ,json['market']!=null?AccountsModel.fromJson(json['market']):null,json['user']!=null?OrderUser.fromJson(json['user']):null,json['date'],json['time'],json['status'],json['discount']);
 }

}

class OrderUser{
 final User? user;

 const OrderUser(this.user);

 factory OrderUser.fromJson(Map<String,dynamic> json){
  return OrderUser(json['user']!=null?User.fromJson(json['user']):null);
 }

}

class User extends Equatable {
 final num? id;
 final String? name;
 final String? phone_code;
 final String? phone;
 final String? gender;
 final num? age;
 final num? height;
 final num? weight;
 final String? type;
 final String? photo;

 const User(this.id, this.name, this.phone_code, this.phone, this.gender,
     this.age, this.height, this.weight, this.type, this.photo);

 factory User.fromJson(Map<String, dynamic> json) {
  return User(
      json['id'],
      json['name'],
      json['phone_code'],
      json['phone'],
      json['gender'],
      json['age'],
      json['height'],
      json['weight'],
      json['type'],
      json['photo']);
 }

 Map<String,dynamic> toJson(){
  return{
   'id':id,
   'name':name,
   'phone_code':phone_code,
   'phone':phone,
   'gender':gender,
   'age':age,
   'height':height,
   'weight':weight,
   'type':type,
   'photo':photo
  };
 }

 @override
 // TODO: implement props
 List<Object?> get props => [id,name,phone_code,phone,gender,age,height,weight,type,photo];
}
