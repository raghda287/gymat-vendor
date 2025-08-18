class PaymentCardModel {
  final num? id;
  final String? card_number;
  final String? card_holder;
  final String? year;
  final String? month;
  final String? type;

  PaymentCardModel(this.id, this.card_number, this.card_holder, this.year,
      this.month, this.type);

  factory PaymentCardModel.fromJson(Map<String,dynamic> json){
    return PaymentCardModel(json['id'],json['card_number'] ,json['card_holder'] ,json['year'] ,json['month'] ,json['type'] );
  }
  String get getCardNumber{
    if(card_number!=null){
      String card = card_number!.replaceAll('-', '  ');
      return card;
    }

    return '';
  }

  String get getCardNumberForCheckType{
    if(card_number!=null){
      String card = card_number!.replaceAll('-', '').replaceAll(' ', '');
      return card;
    }

    return '';
  }
}