import 'package:equatable/equatable.dart';

class DayUnitType extends Equatable{
  String title;
  final String value;

  DayUnitType(this.title, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [title,value];


}