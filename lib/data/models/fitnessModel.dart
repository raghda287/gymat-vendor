class FitnessModel {
  final Goals? goals;
  final num? nutrition_sum;
  final List<Nutrition> nutritions;
  final num? activity_sum;
  final List<Activity> activities;


  FitnessModel(
      this.goals,
      this.nutrition_sum,
      this.nutritions,
      this.activity_sum,
      this.activities,
      );

  factory FitnessModel.fromJson(Map<String, dynamic> json) {
    List<Nutrition> nutritionsList = [];
    List<Activity> activitiesList = [];
    if (json['nutrition'] != null) {
      json['nutrition']
          .forEach((v) => nutritionsList.add(Nutrition.fromJson(v)));
    }

    if (json['activity'] != null) {
      json['activity'].forEach((v) => activitiesList.add(Activity.fromJson(v)));
    }
    return FitnessModel(
      json['goals'] != null ? Goals.fromJson(json['goals']) : null,
      json['nutrition_sum'],
      nutritionsList,
      json['activity_sum'],
      activitiesList,


    );
  }
}

class Goals {
  final num? calories;
  final num? sleep_hours;
  final num? water;
  final num? nutrition_calories;
  final num? activity_calories;
  final num? achieved_calories;
  final num? achieved_water;
  final num? achieved_sleep_hours;

  Goals(this.calories, this.sleep_hours, this.water, this.nutrition_calories,
      this.activity_calories,this.achieved_calories,
      this.achieved_water,
      this.achieved_sleep_hours);

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(json['calories'], json['sleep_hours'], json['water'],
        json['nutrition_calories'], json['activity_calories'],
      json['achieved_calories'],
      json['achieved_water'],
      json['achieved_sleep_hours'],
    );
  }
}

class Nutrition {
  final num? id;
  final String? title;
  final num? calories;

  Nutrition(this.id, this.title, this.calories);

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(json['id'], json['title'], json['calories']);
  }
}

class Activity {
  final num? id;
  final String? title;
  final num? calories;
  final num? minutes;

  Activity(this.id, this.title, this.calories, this.minutes);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        json['id'], json['title'], json['calories'], json['minutes']);
  }
}
