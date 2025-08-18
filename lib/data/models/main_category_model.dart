import 'package:equatable/equatable.dart';

class MainCategoryModel extends Equatable{
  final num? id;
  final String? title;
  final String? type;

  const MainCategoryModel(this.id, this.title, this.type);

  factory MainCategoryModel.fromJson(Map<String,dynamic> map){
    return MainCategoryModel(map['id'], map['title'], map['type']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'title':title,
      'type':type
    };
  }


  @override
  // TODO: implement props
  List<Object?> get props => [id,title,type];

}
