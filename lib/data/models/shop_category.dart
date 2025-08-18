import 'package:equatable/equatable.dart';

class ShopCategory extends Equatable{
  final String title;
  final String value;

  const ShopCategory(this.title, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [title,value];



}