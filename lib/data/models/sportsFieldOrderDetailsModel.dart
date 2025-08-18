import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import 'generalOrderModel.dart';

class SportsFieldOrderDetailsModel {
  final num? id;
  final num? user_id;
  final OrderUser? user;
  final num? market_id;
  final AccountsModel? market;
  final num? total;
  final num? tax;
  final num? app_value;
  final num? discount;
  final num? grand_total;
  final bool? is_paid;
  final Order? order;
  final String? date;
  final String? time;
  String? status;

  SportsFieldOrderDetailsModel(
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

  factory SportsFieldOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return SportsFieldOrderDetailsModel(
        json['id'],
        json['user_id'],
        json['user'] != null ? OrderUser.fromJson(json['user']) : null,
        json['market_id'],
        json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
        json['total'],
        json['tax'],
        json['grand_total'],
        json['is_paid'],
        json['order'] != null ? Order.fromJson(json['order']) : null,
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

class Order {
  final num? id;
  final num? main_order_id;
  final num? service_id;
  final ServiceModel? service;
  final String? date;
  final String? time;
  final String? service_end_at;

  Order(this.id, this.main_order_id, this.service_id, this.service, this.date,
      this.time, this.service_end_at);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['id'],
      json['main_order_id'],
      json['service_id'],
      json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
      json['date'],
      json['time'],
      json['service_end_at'],
    );
  }
}
