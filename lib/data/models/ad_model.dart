import 'package:equatable/equatable.dart';

class AdModel extends Equatable{
  final num? id;
  final num? user_id;
  final num? market_id;
  final num? category_id;
  final String? photo;
  final num? latitude;
  final num? longitude;
  final String? address;
  final num? price;
  final String? from_date;
  final String? to_date;
  final String? page;
  final bool? is_paid;
  final String? pay_link;
  final bool? is_accepted;
  final String? created_at;


  const AdModel(
      this.id,
      this.user_id,
      this.market_id,
      this.category_id,
      this.photo,
      this.latitude,
      this.longitude,
      this.address,
      this.price,
      this.from_date,
      this.to_date,
      this.page,
      this.is_paid,
      this.pay_link,
      this.is_accepted,
      this.created_at);

  factory AdModel.fromJson(Map<String,dynamic> json){
    return AdModel(json['id'],json['user_id'] ,json['market_id'] ,json['category_id'] ,json['photo'] ,json['latitude'] ,json['longitude'] ,json['address'],json['price'] ,json['from_date'] ,json['to_date'] ,json['page'] ,json['is_paid'] ,json['pay_link'] ,json['is_accepted'] ,json['created_at'] );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,user_id,market_id,category_id,photo,latitude,longitude,address,price,from_date,to_date,page,is_paid,pay_link,is_accepted,created_at];



}