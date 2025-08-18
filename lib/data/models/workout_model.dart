import 'package:equatable/equatable.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/subscribtion_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';

class WorkoutModel extends Equatable {
  final num? id;
  final String? title;
  final String? trans_title;
  final String? text;
  final String? trans_text;
  final String? photo;
  final num? market_id;
  final AccountsModel? market;
  final num? duration;
  final num? calories;
  final List<WorkoutVideoModel> videos;

  const WorkoutModel(
      this.id,
      this.title,
      this.trans_title,
      this.text,
      this.trans_text,
      this.photo,
      this.market_id,
      this.market,
      this.duration,
      this.calories,
      this.videos);

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    List<WorkoutVideoModel> list = [];
    if (json['videos'] != null) {
      json['videos'].forEach((v) => list.add(WorkoutVideoModel.fromJson(v)));
    }
    return WorkoutModel(
        json['id'],
        json['title'],
        json['trans_title'],
        json['text'],
        json['trans_text'],
        json['photo'],
        json['market_id'],
        json['market'] != null ? AccountsModel.fromJson(json['market']) : null,
        json['time'],
        json['calories'],
        list);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        title,
        trans_title,
        text,
        trans_text,
        photo,
        market_id,
        market,
        duration,
        calories,
        videos
      ];
}

class WorkoutVideoModel extends Equatable {
  final num? id;
  final String? video;
  final String? image;
  final String? duration;
  final num? aspect_ratio;
  final String? name;

  const WorkoutVideoModel(this.id, this.video, this.image, this.duration,
      this.aspect_ratio, this.name);

  factory WorkoutVideoModel.fromJson(Map<String, dynamic> json) {
    return WorkoutVideoModel(json['id'], json['video'], json['image'],
        json['duration'], json['aspect_ratio'], json['name']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, video, image, duration, aspect_ratio, name];
}
