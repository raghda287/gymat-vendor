
class WalletModel  {
  final num? wallet;
  final List<WalletDetails> details;

  WalletModel(this.wallet, this.details);

  factory WalletModel.fromJson(Map<String,dynamic> json){
    List<WalletDetails> list = [];
    if(json['details']!=null){
      json['details'].forEach((v)=>list.add(WalletDetails.fromJson(v)));
    }
    return WalletModel(json['wallet'], list);
  }

}

class WalletDetails{
  final String? date;
  final String? time;
  final num? value;
  final String? type;

  WalletDetails(this.date, this.time, this.value, this.type);

  factory WalletDetails.fromJson(Map<String,dynamic> json){

    return WalletDetails(json['date'],json['time'] ,json['value'] ,json['type'] );
  }
}