import 'dart:convert';

import 'package:gymatvendor/data/models/shop_service_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import 'addressesModel.dart';
import 'generalOrderModel.dart';

class ShopOrderDetailsModel {
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
  final OrderShop? order;
  final String? date;
  final String? time;
  String? status;

  ShopOrderDetailsModel(
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

  factory ShopOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShopOrderDetailsModel(
      json['id'],
      json['user_id'],
      json['user'] != null ? OrderUser.fromJson(json['user']) : null,
      json['market_id'],
      json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
      json['total'],
      json['tax'],
      json['grand_total'],
      json['is_paid'],
      json['order'] != null ? OrderShop.fromJson(json['order']) : null,
      json['date'],
      json['time'],
      json['status'],
      json['discount'],
      json['app_value'],
    );
  }
}

class OrderUser {
  final User? user;

  const OrderUser(this.user);

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(json['user'] != null ? User.fromJson(json['user']) : null);
  }
}

class OrderShop {
  final num? id;
  final num? main_order_id;
  final String? product_id;
  final num? address_id;
  final AddressesModel? address;
  final String? phone_code;
  final String? phone;
  String? delivery_date;
  final List<OrderShopDetails> details;

  OrderShop(
      this.id,
      this.main_order_id,
      this.product_id,
      this.address_id,
      this.address,
      this.phone_code,
      this.phone,
      this.delivery_date,
      this.details);

  factory OrderShop.fromJson(Map<String, dynamic> json) {
    List<OrderShopDetails> list = [];

    if (json['details'] != null) {
      json['details'].forEach((v) => list.add(OrderShopDetails.fromJson(v)));
    }
    return OrderShop(
        json['id'],
        json['main_order_id'],
        json['product_id'],
        json['address_id'],
        json['address'] != null
            ? AddressesModel.fromJson(json['address'])
            : null,
        json['phone_code'],
        json['phone'],
        json['delivery_date'],
        list);
  }
}

class OrderShopDetails {
  final num? id;
  final num? main_order_id;
  final num? order_id;
  final num? product_id;
  final num? product_price_id;
  final ShopServiceModel? product;
  final ProductPrice? product_price;
  final num? net_cost;
  final num? qty;
  final num? total;
  final String? note;

  OrderShopDetails(
      this.id,
      this.main_order_id,
      this.order_id,
      this.product_id,
      this.product,
      this.net_cost,
      this.qty,
      this.total,
      this.note,
      this.product_price_id,
      this.product_price);

  factory OrderShopDetails.fromJson(Map<String, dynamic> json) {
    return OrderShopDetails(
        json['id'],
        json['main_order_id'],
        json['order_id'],
        json['product_id'],
        json['product'] != null
            ? ShopServiceModel.fromJson(json['product'])
            : null,
        json['net_cost'],
        json['qty'],
        json['total'],
        json['note'],
        json['product_price_id'],
        json['product_price'] != null
            ? ProductPrice.fromJson(json['product_price'])
            : null);
  }
}

class ProductPrice {
  final num? id;
  final String? title;
  final num? price;
  final num? new_price;
  final num? offer_value;
  final String? offer_type;
  final bool? has_offer;

  ProductPrice(this.id, this.title, this.price, this.new_price,
      this.offer_value, this.offer_type, this.has_offer);

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
        json['id'],
        json['title'],
        json['price'],
        json['new_price'],
        json['offer_value'],
        json['offer_type'],
        json['has_offer']);
  }
}
