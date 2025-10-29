import 'dart:convert';

CourseResponse courseResponseFromJson(String str) => CourseResponse.fromJson(json.decode(str));

String courseResponseToJson(CourseResponse data) => json.encode(data.toJson());

class CourseResponse {
    CourseResponse({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    List<CourseData> data;
    String message;

    factory CourseResponse.fromJson(Map<dynamic, dynamic> json) => CourseResponse(
        code: json["code"],
        data: List<CourseData>.from(json["data"].map((x) => CourseData.fromJson(x))),
        message: json["message"],
    );

    Map<dynamic, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class CourseData {
    CourseData({
        required this.price,
        required this.description,
        required this.id,
        required this.title,
        required this.image,
        required this.isFree
    });

    int price;
    String description;
    int id;
    String title;
    String image;
    bool isFree;

    factory CourseData.fromJson(Map<dynamic, dynamic> json) => CourseData(
        price: json["price"],
        description: json["description"],
        id: json["id"],
        title: json["title"],
        image: json["image"],
        isFree: json["is_free"]
    );

    Map<dynamic, dynamic> toJson() => {
        "price": price,
        "description": description,
        "id": id,
        "title": title,
        "image": image,
        "is_free": isFree
    };
}
