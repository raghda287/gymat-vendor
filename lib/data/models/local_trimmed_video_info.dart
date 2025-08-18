import 'package:equatable/equatable.dart';

class LocalTrimmedVideoInfo extends Equatable{
  final String? path;
  final num? aspectRatio;

  const LocalTrimmedVideoInfo(this.path, this.aspectRatio);

  @override
  // TODO: implement props
  List<Object?> get props => [path,aspectRatio];
}