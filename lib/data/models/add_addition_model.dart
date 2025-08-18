import 'package:equatable/equatable.dart';

class AddAditionModel extends Equatable{
  final String name;
  final num price;
  final num? newPrice;
  final bool? has_offer;
  final num? offer_value;
  final String? offer_type;


  const AddAditionModel(this.name, this.price, this.has_offer, this.offer_value, this.offer_type, this.newPrice);

  @override
  // TODO: implement props
  List<Object?> get props => [name,price,has_offer,offer_value,offer_type,newPrice];

  Map<String,dynamic> toJson(){
    return {
      'title':name,
      'price':price,
      'has_offer':has_offer!=null?has_offer!?1:0:null,
      'offer_value':offer_value,
      'offer_type':offer_type
    };
  }
}