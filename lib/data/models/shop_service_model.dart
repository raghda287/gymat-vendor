import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/subscribtion_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

class ShopServiceModel extends Equatable {
  final num? id;
  final String? title;
  final String? trans_title;
  final String? text;
  final String? trans_text;
  final num? market_id;
  final AccountsModel? market;
  final num? category_id;
  final DepartmentModel? category;
  final num? main_category_id;
  final DepartmentModel? main_category;
  final List<Photo> images;
  final List<Details> details;

  const ShopServiceModel(
      this.id,
      this.title,
      this.trans_title,
      this.text,
      this.trans_text,
      this.market_id,
      this.market,
      this.category_id,
      this.category,
      this.main_category_id,
      this.main_category,
      this.images,
      this.details);

  factory ShopServiceModel.fromJson(Map<String, dynamic> json) {
    List<Photo> listPhoto = [];
    if (json['images'] != null) {
      json['images'].forEach((v) => listPhoto.add(Photo.fromJson(v)));
    }
    List<Details> listDetails = [];

    if (json['details'] != null) {
      json['details'].forEach((v) => listDetails.add(Details.fromJson(v)));
    }
    return ShopServiceModel(
        json['id'],
        json['title'],
        json['trans_title'],
        json['text'],
        json['trans_text'],
        json['market_id'],
        json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
        json['category_id'],
        json['category'] != null
            ? DepartmentModel.fromJson(json['category'])
            : null,
        json['main_category_id'],
        json['main_category'] != null
            ? DepartmentModel.fromJson(json['main_category'])
            : null,
        listPhoto,
        listDetails);
  }

  String getTitle() {
    String t = "";

    if (trans_title != null) {
      if (trans_title!.startsWith('trans.')) {
        if(title!=null && title!.startsWith("trans.")){
          t = title!.replaceFirst('trans.', '');
        }else{
          t = title ?? '';

        }
      } else {

        if(trans_title!=null&&trans_title!.startsWith('trans.')){
          t = trans_title!.replaceFirst('trans.', '');

        }else{
          t = trans_title??"";

        }
      }
    }else{

      t = title??'';
    }
    return t;
  }

  String getText() {
    String txt = "";
    if (trans_text != null) {
      if (trans_text!.startsWith('trans.')) {
        if(text!=null&&text!.startsWith('trans.')){
          txt = text!.replaceFirst('trans.', '');
        }else{
          txt = text ?? '';

        }

      } else {
        if(trans_text!=null&&trans_text!.startsWith('trans.')){
          txt = trans_text!.replaceFirst('trans.', '');
        }else{
          txt = trans_text??'';

        }
      }
    }else{
      txt = text??'';
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
        market_id,
        market,
        category_id,
        category,
        images
      ];
}

class Photo extends Equatable {
  final num? id;
  final String? image;

  const Photo(this.id, this.image);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json['id'], json['image']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, image];
}

class Details extends Equatable {
  final num? id;
  final num? price;
  final String? title;
  final num? new_price;
  final num? offer_value;
  final String? offer_type;
  final bool? has_offer;

  const Details(this.id, this.price, this.title, this.new_price, this.offer_value, this.offer_type, this.has_offer);

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(json['id'], json['price'], json['title'], json['new_price'],
      json['offer_value'],
      json['offer_type'],
      json['has_offer'],);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, price, title,new_price, offer_value, offer_type, has_offer];
}
