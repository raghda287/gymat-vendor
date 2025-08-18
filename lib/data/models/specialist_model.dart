import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/department_model.dart';

class Specialist extends Equatable{
  final num? id;
  final String? name;
  final String? image;
  final num? category_id;
  final List<DepartmentModel> categories;

  const Specialist(this.id, this.name, this.image, this.category_id, this.categories);

  factory Specialist.fromJson(Map<String,dynamic> json){
    List<DepartmentModel> list = [];
    if(json['categories']!=null){
      json['categories'].forEach((v)=>list.add(DepartmentModel.fromJson(v)));
    }
    return Specialist(json['id'],json['name'] , json['image'], json['category_id'], list);
  }


  @override
  // TODO: implement props
  List<Object?> get props => [id,name,image,category_id,categories];
}