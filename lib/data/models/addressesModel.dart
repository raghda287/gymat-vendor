class AddressesModel {
  final num? id;
  final String? title;
  final String? type;
  final String? address;
  final num? latitude;
  final num? longitude;

  AddressesModel(this.id, this.title, this.type, this.address, this.latitude, this.longitude);

  factory AddressesModel.fromJson(Map<String,dynamic> json){

    return AddressesModel(json['id'],json['title'] ,json['type'] ,json['address'] ,json['latitude'] ,json['longitude'] );
  }
}