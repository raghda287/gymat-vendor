import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class LocalWorkoutVideoModel extends Equatable{
  final num? id;
  final VideoThumbnail videoThumbnail;
  final String videoTitle;
  final String duration;
  final num? aspectRatio;

  const LocalWorkoutVideoModel(this.id,this.videoThumbnail, this.videoTitle, this.duration, this.aspectRatio);

  @override
  // TODO: implement props
  List<Object?> get props => [id,videoThumbnail,videoTitle,duration,aspectRatio];

  Future<Map<String, dynamic>> toJson() async{
    MultipartFile? imageFile;
    MultipartFile? videoFile;

    if(!videoThumbnail.videoImagePath.startsWith('http')){
      videoThumbnail.videoImagePath = videoThumbnail.videoImagePath.replaceFirst('fileimage:', '');
      imageFile = await MultipartFile.fromFile(videoThumbnail.videoImagePath);
    }
    if(!videoThumbnail.videoPath.startsWith('http')){
      videoFile = await MultipartFile.fromFile(videoThumbnail.videoPath);

    }


    Map<String,dynamic> map = {
      'id':id,
      'image':imageFile,
      'duration':duration,
      'name':videoTitle,
      'aspect_ratio':aspectRatio,
      'video':videoFile
    };

    return Future.value(map);
  }


}

class VideoThumbnail extends Equatable{
   String videoPath;
   String videoImagePath;

   VideoThumbnail(this.videoPath, this.videoImagePath);

  @override
  // TODO: implement props
  List<Object?> get props => [videoPath,videoImagePath];
}