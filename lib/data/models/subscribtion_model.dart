import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

class SubscribtionModel extends Equatable {

  final num? id;
  final String? title;
  final String? trans_title;
  final num? price;
  final num? new_price;
  final String? offer_type;
  final bool? has_offer;
  final num? offer_value;
  final num? service_time;
  final String? service_time_name;

  const SubscribtionModel(this.id, this.title, this.trans_title, this.price, this.service_time, this.service_time_name, this.new_price, this.offer_type, this.has_offer, this.offer_value);

  factory SubscribtionModel.fromJson(Map<String, dynamic> json){
    return SubscribtionModel(
        json['id'], json['title'], json['trans_title'], json['price'],json['service_time'],json['service_time_name'],json['new_price'],json['offer_type'],json['has_offer'],json['offer_value']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title':title,
      'trans_title':trans_title,
      'price':price,
      'service_time':service_time,
      'service_time_name':service_time_name,
      'new_price':new_price,
      'offer_type':offer_type,
      'has_offer':has_offer!=null?has_offer!?1:0:null,
      'offer_value':offer_value
    };
  }

  String getTitle(){
    String t = "";
    if (service_time == 1 && service_time_name == 'Day') {
      t ='1 ${'DayUnit'.tr()}';

    } else if (service_time == 1 && service_time_name == 'Month') {
      t ='1 ${'MonthUnit'.tr()}';

    } else if (service_time == 3 && service_time_name == 'Month') {
      t ='3 ${'MonthsUnit'.tr()}';

    } else if (service_time == 6 && service_time_name == 'Month') {
      t ='6 ${'MonthsUnit'.tr()}';

    } else if (service_time == 1 && service_time_name == 'Year') {
      t ='1 ${'YearUnit'.tr()}';

    }
    return t;
  }

  @override
  List<Object?> get props => [id, title, trans_title, price,service_time,service_time_name,new_price,offer_type,has_offer,offer_value];
}