import 'package:equatable/equatable.dart';

class LocalDayModel extends Equatable{
  final String title;
  final String value;

  const LocalDayModel(this.title, this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [title,value];
}