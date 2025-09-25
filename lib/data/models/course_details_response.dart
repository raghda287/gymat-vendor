
import 'dart:convert';

CourseDetailsResponse courseDetailsResponseFromJson(String str) => CourseDetailsResponse.fromJson(json.decode(str));

String courseDetailsResponseToJson(CourseDetailsResponse data) => json.encode(data.toJson());

class CourseDetailsResponse {
    CourseDetailsResponse({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    CourseDetailsData data;
    String message;

    factory CourseDetailsResponse.fromJson(Map<dynamic, dynamic> json) => CourseDetailsResponse(
        code: json["code"],
        data: CourseDetailsData.fromJson(json["data"]),
        message: json["message"],
    );

    Map<dynamic, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
    };
}

class CourseDetailsData {
    CourseDetailsData({
        required this.sessions,
        required this.price,
        required this.description,
        required this.id,
        required this.title,
    });

    List<Session> sessions;
    int price;
    String description;
    int id;
    String title;

    factory CourseDetailsData.fromJson(Map<dynamic, dynamic> json) => CourseDetailsData(
        sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
        price: json["price"],
        description: json["description"],
        id: json["id"],
        title: json["title"],
    );

    Map<dynamic, dynamic> toJson() => {
        "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
        "price": price,
        "description": description,
        "id": id,
        "title": title,
    };
}

class Session {
    Session({
        required this.date,
        required this.channelName,
        required this.courseId,
        required this.file,
        required this.isFree,
        required this.description,
        required this.id,
        required this.title,
        required this.type,
        required this.toTime,
        required this.fromTime,
    });

    DateTime date;
    String channelName;
    int courseId;
    String file;
    bool isFree;
    String description;
    int id;
    String title;
    String type;
    String toTime;
    String fromTime;

    factory Session.fromJson(Map<dynamic, dynamic> json) => Session(
        date: DateTime.parse(json["date"]),
        channelName: json["channel_name"],
        courseId: json["course_id"],
        file: json["file"],
        isFree: json["is_free"],
        description: json["description"],
        id: json["id"],
        title: json["title"],
        type: json["type"],
        toTime: json["to_time"],
        fromTime: json["from_time"],
    );

    Map<dynamic, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "channel_name": channelName,
        "course_id": courseId,
        "file": file,
        "is_free": isFree,
        "description": description,
        "id": id,
        "title": title,
        "type": type,
        "to_time": toTime,
        "from_time": fromTime,
    };
}
