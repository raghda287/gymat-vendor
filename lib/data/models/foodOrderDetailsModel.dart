import 'dart:convert';

import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import 'addressesModel.dart';
import 'generalOrderModel.dart';

class FoodOrderDetailsModel {
  final num? id;
  final num? user_id;
  final OrderUser? user;
  final num? market_id;
  final AccountsModel? market;
  final num? total;
  final num? tax;
  final num? app_value;
  final num? grand_total;
  final num? discount;
  final bool? is_paid;
  final OrderFood? order;
  final String? date;
  final String? time;
  String? status;

  FoodOrderDetailsModel(
      this.id,
      this.user_id,
      this.user,
      this.market_id,
      this.market,
      this.total,
      this.tax,
      this.grand_total,
      this.is_paid,
      this.order,
      this.date,
      this.time,
      this.status,
      this.discount,
      this.app_value);

  factory FoodOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return FoodOrderDetailsModel(
        json['id'],
        json['user_id'],
        json['user'] != null ? OrderUser.fromJson(json['user']) : null,
        json['market_id'],
        json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
        json['total'],
        json['tax'],
        json['grand_total'],
        json['is_paid'],
        json['order'] != null ? OrderFood.fromJson(json['order']) : null,
        json['date'],
        json['time'],
        json['status'],
        json['discount'],
        json['app_value']);
  }
}

class OrderUser {
  final User? user;

  const OrderUser(this.user);

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(json['user'] != null ? User.fromJson(json['user']) : null);
  }
}

class OrderFood {
  final num? id;
  final num? main_order_id;
  final String? type;
  final num? address_id;
  final AddressesModel? address;
  final bool? is_call;
  final String? delivery_type_time;
  final String? date;
  final String? time;
  final List<OrderFoodDetails> details;

  OrderFood(
      this.id,
      this.main_order_id,
      this.type,
      this.address_id,
      this.address,
      this.is_call,
      this.delivery_type_time,
      this.date,
      this.time,
      this.details);

  factory OrderFood.fromJson(Map<String, dynamic> json) {
    List<OrderFoodDetails> list = [];

    if (json['details'] != null) {
      json['details'].forEach((v) => list.add(OrderFoodDetails.fromJson(v)));
    }
    return OrderFood(
        json['id'],
        json['main_order_id'],
        json['type'],
        json['address_id'],
        json['address'] != null
            ? AddressesModel.fromJson(json['address'])
            : null,
        json['is_call'],
        json['delivery_type_time'],
        json['date'],
        json['time'],
        list);
  }
}

class OrderFoodDetails {
  final num? id;
  final num? main_order_id;
  final num? order_id;
  final num? service_id;
  final ServiceModel? serviceModel;
  final num? net_cost;
  final num? qty;
  final num? total;
  final String? note;

  OrderFoodDetails(this.id, this.main_order_id, this.order_id, this.service_id,
      this.serviceModel, this.net_cost, this.qty, this.total, this.note);

  factory OrderFoodDetails.fromJson(Map<String, dynamic> json) {
    return OrderFoodDetails(
        json['id'],
        json['main_order_id'],
        json['order_id'],
        json['service_id'],
        json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
        json['net_cost'],
        json['qty'],
        json['total'],
        json['note']);
  }
}
