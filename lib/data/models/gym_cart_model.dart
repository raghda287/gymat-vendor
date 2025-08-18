import 'package:equatable/equatable.dart';
class GymCartModel extends Equatable{
  final int id;
  final String? image;
  final String? title;
  final String price;

  const GymCartModel(this.id, this.image, this.title, this.price);
  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'image':image,
      'title':title,
      'price':price
    };
  }

  @override
  List<Object?> get props => [id,image,title,price];


}