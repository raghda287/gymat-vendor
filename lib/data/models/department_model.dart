import 'package:equatable/equatable.dart';

class DepartmentModel extends Equatable{
  final num? id;
  final String? title;
  final String? trans_title;
  final num? parent_id;

  const DepartmentModel(this.id, this.title, this.trans_title,this.parent_id);


  factory DepartmentModel.fromJson(Map<String,dynamic> json){
    return DepartmentModel(json['id'], json['title'],json['trans_title'],json['parent_id']);
  }

  String getTitle(){
    String t = "";

    if (trans_title != null) {
      if (trans_title!.startsWith('trans.')) {
        if(title!=null && title!.startsWith("trans.")){
          t = title!.replaceFirst('trans.', '');
        }else{
          t = title ?? '';

        }
      } else {

        if(trans_title!=null&&trans_title!.startsWith('trans.')){
          t = trans_title!.replaceFirst('trans.', '');

        }else{
          t = trans_title??"";

        }
      }
    }else{

      t = title??'';
    }
    return t;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,title];

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'title':title,
      'trans_title':trans_title,
      'parent_id':parent_id,
    };
  }
}