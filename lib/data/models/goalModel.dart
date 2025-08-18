
class GoalModel {
  final num? id;
  final num? daily;
  final num? monthly;
  final num? yearly;

  const GoalModel(this.id, this.daily, this.monthly, this.yearly);

  factory GoalModel.fromJson(Map<String,dynamic> json){
    return GoalModel(json['id'],json['daily'] ,json['monthly'] ,json['yearly'] );

  }
}