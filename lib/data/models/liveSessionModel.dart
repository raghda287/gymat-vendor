
import 'package:gymatvendor/data/models/user_model.dart';
enum LiveSessionStatus{
 NEW,
 LIVE,
 ENDED,
 EXPIRED
}
class LiveSessionModel {
 final num? id;
 final String? title;
 final String? trans_title;
 final String? text;
 final String? trans_text;
 final String? photo;
 final num? market_id;
 final AccountsModel? market;
 final num? price;
 final num? new_price;
 final String? date;
 final String? from_time;
 final String? to_time;
 final num? offer_value;
 final String? offer_type;
 final bool? has_offer;
 final num? people_registered;
 String? status;
 final bool? is_paid;
 final String? link;
 final String? end_time_link;
 final String? end_link;


 LiveSessionModel(
     this.id,
     this.title,
     this.trans_title,
     this.text,
     this.trans_text,
     this.photo,
     this.market_id,
     this.market,
     this.price,
     this.new_price,
     this.date,
     this.from_time,
     this.to_time,
     this.offer_value,
     this.offer_type,
     this.has_offer,
     this.link,
     this.people_registered,
     this.status,
     this.is_paid,
     this.end_time_link,
     this.end_link);

 factory LiveSessionModel.fromJson(Map<String, dynamic> json) {
  return LiveSessionModel(
   json['id'],
   json['title'],
   json['trans_title'],
   json['text'],
   json['trans_text'],
   json['photo'],
   json['market_id'],
   json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
   json['price'],
   json['new_price'],
   json['date'],
   json['from_time'],
   json['to_time'],
   json['offer_value'],
   json['offer_type'],
   json['has_offer'],
   json['link'],
   json['people_registered'],
   json['status'],
   json['is_paid'],
   json['end_time_link'],
   json['end_link'],
  );
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

}