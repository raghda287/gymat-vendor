import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/main_category_model.dart';

class UserModel extends Equatable {
  final ProviderModel? providerModel;
  final String auth;

  const UserModel(this.providerModel, this.auth);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(ProviderModel.fromJson(json['provider']), json['auth']);
  }

  Map<String, dynamic> toJson() {
    return {'provider': providerModel?.toJson(), 'auth': auth};
  }

  @override
  // TODO: implement props
  List<Object?> get props => [providerModel, auth];
}

class ProviderModel extends Equatable {
  final num? id;
  final String? name;
  final String? phone_code;
  final String? phone;
  final String? email;
  final String? gender;
  final List<AccountsModel> accounts;
  AccountsModel? mainAccount;
  bool sign_info;
  bool is_accepted;

  ProviderModel(this.id,
      this.name,
      this.phone_code,
      this.phone,
      this.email,
      this.gender,
      this.accounts,
      this.sign_info,
      this.is_accepted,);

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    List<AccountsModel> list = [];
    if (json.containsKey('markets')) {
      json['markets'].forEach((v) => list.add(AccountsModel.fromJson(v)));
    }
    return ProviderModel(
      json['id'],
      json['name'],
      json['phone_code'],
      json['phone'],
      json['email'],
      json['gender'],
      list,
      json['sign_info'],
      json['is_accepted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_code': phone_code,
      'phone': phone,
      'email': email,
      'gender': gender,
      'markets': accounts.map((e) => e.toJson()).toList(),
      'mainAccount': mainAccount?.toJson(),
      'sign_info': sign_info,
      'is_accepted': is_accepted,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, phone_code, phone, email, gender, accounts];
}

class AccountsModel extends Equatable {
  final num? id;
  final num? user_id;
  final num? category_id;
  final MainCategoryModel category;
  final String? address;
  final num? latitude;
  final num? longitude;
  final String? business_name;
  final String? phone_code;
  final String? phone;
  final String? desc;
  final String? logo;
  final String? background;
  final String? email;
  final String? for_gender;
  final bool? is_navigation;
  final num? rate;
  num? followers_count;
  final String? website;
  final List<WorkTime> work_times;
  final num? price_day;
  final List<ShopCategory> shop_categories;
  final bool? is_delivery;
  final String? education;
  final String? certifications;
  final String? experience;
  bool? is_notification;
  bool? is_message;
  bool? bookable;
  List<IdentificationData> certificates;

  final UserDataCertification? user_data;


  AccountsModel(this.id,
      this.user_id,
      this.category_id,
      this.address,
      this.latitude,
      this.longitude,
      this.business_name,
      this.phone_code,
      this.phone,
      this.desc,
      this.logo,
      this.background,
      this.email,
      this.for_gender,
      this.is_navigation,
      this.rate,
      this.category,
      this.followers_count,
      this.website,
      this.work_times,
      this.price_day,
      this.shop_categories,
      this.is_delivery,
      this.education,
      this.certifications,
      this.experience,
      this.is_notification,
      this.is_message,
      this.bookable,
      this.user_data,
      this.certificates
      );

  factory AccountsModel.fromJson(Map<String, dynamic> json) {
    List<WorkTime> workTimes = [];
    if (json['work_times'] != null) {
      json['work_times'].forEach((v) => workTimes.add(WorkTime.fromJson(v)));
    }
    List<ShopCategory> shopCategories = [];

    if (json['shop_categories'] != null) {
      json['shop_categories']
          .forEach((v) => shopCategories.add(ShopCategory.fromJson(v)));
    }
    List<IdentificationData> certificatesList = [];

    if (json['certificates'] != null) {
      json['certificates'].forEach((v) => certificatesList.add(IdentificationData.fromJson(v)));
    }

    return AccountsModel(
      json['id'],
      json['user_id'],
      json['category_id'],
      json['address'],
      json['latitude'],
      json['longitude'],
      json['business_name'],
      json['phone_code'],
      json['phone'],
      json['desc'],
      json['logo'],
      json['background'],
      json['email'],
      json['for_gender'],
      json['is_navigation'],
      json['rate'],
      MainCategoryModel.fromJson(json['category']),
      json['followers_count'],
      json['website'],
      workTimes,
      json['price_day'],
      shopCategories,
      json['is_delivery'],
      json['education'],
      json['certifications'],
      json['experience'],
      json['is_notification'],
      json['is_message'],
      json['bookable'],
      json['user_data']!=null?UserDataCertification.fromJson(json['user_data']):null,
      certificatesList
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'category_id': category_id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'business_name': business_name,
      'phone_code': phone_code,
      'phone': phone,
      'desc': desc,
      'logo': logo,
      'background': background,
      'email': email,
      'for_gender': for_gender,
      'is_navigation': is_navigation,
      'rate': rate,
      'category': category.toJson(),
      'followers_count': followers_count,
      'website': website,
      'work_times': work_times.map((e) => e.toJson()).toList(),
      'price_day': price_day,
      'shop_categories': shop_categories,
      'is_delivery': is_delivery,
      'education': education,
      'certifications': certifications,
      'experience': experience,
      'is_notification': is_notification,
      'is_message': is_message,
      'bookable': bookable,
      'user_data':user_data?.toJson(),
      'certificates':certificates.map((e) => e.toJson()).toList(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        user_id,
        category_id,
        address,
        latitude,
        longitude,
        business_name,
        phone_code,
        phone,
        desc,
        logo,
        background,
        email,
        for_gender,
        is_navigation,
        rate,
        category,
        followers_count,
        website,
        price_day,
        work_times,
        shop_categories
      ];
}

class UserDataCertification extends Equatable {
  List<IdentificationData> certificates;
  final IdentificationData? com_register;
  final IdentificationData? passport;
  final IdentificationData? id_photo;

  UserDataCertification(this.certificates, this.com_register, this.passport, this.id_photo);
  factory UserDataCertification.fromJson(Map<String, dynamic> json){
     List<IdentificationData> list = [];
     if(json['certificates']!=null){
       json['certificates'].forEach((v)=>list.add(IdentificationData.fromJson(v)));
     }
    return UserDataCertification(list, json['com_register']!=null?IdentificationData.fromJson(json['com_register']):null, json['passport']!=null?IdentificationData.fromJson(json['passport']):null, json['passport']!=null?IdentificationData.fromJson(json['id_photo']):null);

  }

  Map<String,dynamic> toJson(){
    return{
      'certificates':certificates.map((e) => e.toJson()).toList(),
      'com_register':com_register?.toJson(),
      'passport':passport?.toJson(),
      'id_photo':id_photo?.toJson(),

    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [certificates,com_register,passport,id_photo];
}

class IdentificationData extends Equatable {
  final num? id;
  final String? image;

  const IdentificationData(this.id, this.image);

  factory IdentificationData.fromJson(Map<String, dynamic> json){
    return IdentificationData(json['id'], json['image']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image
    };
  }


  @override
  // TODO: implement props
  List<Object?> get props => [id,image];
}

class WorkTime extends Equatable {
  final num? id;
  final String? day;
  final String? from_time;
  final String? to_time;

  const WorkTime(this.id, this.day, this.from_time, this.to_time);

  factory WorkTime.fromJson(Map<String, dynamic> json) {
    return WorkTime(
        json['id'], json['day'], json['from_time'], json['to_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'from_time': from_time,
      'to_time': to_time,
    };
  }

  @override
  List<Object?> get props => [id, day, from_time, to_time];
}

class ShopCategory extends Equatable {
  final num? id;
  final num? category_id;
  final DepartmentModel? category;

  const ShopCategory(this.id, this.category_id, this.category);

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
        json['id'],
        json['category_id'],
        json['category'] != null
            ? DepartmentModel.fromJson(json['category'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': category_id,
      'category': category?.toJson(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, category_id, category];
}
