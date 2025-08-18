import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/subscribtion_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

class ServiceModel extends Equatable {
  final num? id;
  final String? title;
  final String? trans_title;
  final String? text;
  final String? trans_text;
  final String? photo;
  final num? market_id;
  final AccountsModel? market;
  final num? category_id;
  final DepartmentModel? category;
  final num? price;
  final num? basic_price;
  final num? new_price;
  final num? offer_value;
  final String? offer_type;
  final bool? has_offer;
  final num? service_time;
  final String? service_time_name;
  final List<SubscribtionModel> options;
  final num? preparation_time;
  final num? calories;

  const ServiceModel(
      this.id,
      this.title,
      this.trans_title,
      this.text,
      this.trans_text,
      this.photo,
      this.market_id,
      this.market,
      this.category_id,
      this.category,
      this.price,
      this.service_time,
      this.service_time_name,
      this.options,
      this.preparation_time,
      this.calories,
      this.new_price,
      this.offer_value,
      this.offer_type,
      this.has_offer,
      this.basic_price);

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    List<SubscribtionModel> list = [];
    if (json['options'] != null) {
      json['options'].forEach((v) => list.add(SubscribtionModel.fromJson(v)));
    }
    return ServiceModel(
        json['id'],
        json['title'],
        json['trans_title'],
        json['text'],
        json['trans_text'],
        json['photo'],
        json['market_id'],
        json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
        json['category_id'],
        json['category'] != null
            ? DepartmentModel.fromJson(json['category'])
            : null,
        json['price'],
        json['service_time'],
        json['service_time_name'],
        list,
        json['preparation_time'],
        json['calories'],
        json['new_price'],
        json['offer_value'],
        json['offer_type'],
        json['has_offer'],
        json['basic_price']);
  }

  String getTitle() {
    String t = "";

    if (trans_title != null) {
      if (trans_title!.startsWith('trans.')) {
        if (title != null && title!.startsWith("trans.")) {
          t = title!.replaceFirst('trans.', '');
        } else {
          t = title ?? '';
        }
      } else {
        if (trans_title != null && trans_title!.startsWith('trans.')) {
          t = trans_title!.replaceFirst('trans.', '');
        } else {
          t = trans_title ?? "";
        }
      }
    } else {
      t = title ?? '';
    }
    return t;
  }

  String getText() {
    String txt = "";
    if (trans_text != null) {
      if (trans_text!.startsWith('trans.')) {
        if (text != null && text!.startsWith('trans.')) {
          txt = text!.replaceFirst('trans.', '');
        } else {
          txt = text ?? '';
        }
      } else {
        if (trans_text != null && trans_text!.startsWith('trans.')) {
          txt = trans_text!.replaceFirst('trans.', '');
        } else {
          txt = trans_text ?? '';
        }
      }
    } else {
      txt = text ?? '';
    }
    return txt;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        title,
        trans_title,
        text,
        trans_text,
        photo,
        market_id,
        market,
        category_id,
        category,
        price,
        service_time,
        service_time_name,
        options,
        preparation_time,
        calories,
        new_price,
        offer_value,
        offer_type,
        has_offer
      ];
}
