class ChartModel {
  final String title;
  final num value;

  ChartModel(this.title, this.value);
  
  factory ChartModel.fromJson(Map<String,dynamic> json){
    return ChartModel(json['title'],json['value'] );
  }
}