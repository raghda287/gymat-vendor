import 'dart:convert';

CourseDetailsResponse courseDetailsResponseFromJson(String str) =>
    CourseDetailsResponse.fromJson(json.decode(str));

String courseDetailsResponseToJson(CourseDetailsResponse data) =>
    json.encode(data.toJson());

class CourseDetailsResponse {
    CourseDetailsResponse({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    CourseDetailsData data;
    String message;

    factory CourseDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
        return CourseDetailsResponse(
            code: _toInt(json["code"]),
            data: CourseDetailsData.fromJson(json["data"] ?? {}),
            message: json["message"]?.toString() ?? "",
        );
    }

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
        required this.image,
        required this.isFree,
    });

    List<Session> sessions;
    int price;
    String description;
    int id;
    String title;
    String image;
    bool isFree;

    factory CourseDetailsData.fromJson(Map<dynamic, dynamic> json) {
        return CourseDetailsData(
            sessions: json["sessions"] == null
                ? []
                : List<Session>.from(
                json["sessions"].map((x) => Session.fromJson(x)),
            ),
            price: _toInt(json["price"]),
            description: json["description"]?.toString() ?? "",
            id: _toInt(json["id"]),
            title: json["title"]?.toString() ?? "",
            image: json["image"]?.toString() ?? "",
            isFree: _toBool(json["is_free"]),
        );
    }

    Map<dynamic, dynamic> toJson() => {
        "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
        "price": price,
        "description": description,
        "id": id,
        "title": title,
        "image": image,
        "is_free": isFree,
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
        required this.status,
        required this.canPlayRecording,
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
    String status;
    bool canPlayRecording;

    bool get isLive => type.toLowerCase() == "live";

    bool get isEnded => status.toLowerCase() == "ended";

    bool get hasValidFile =>
        file.isNotEmpty && !file.contains("default/no_image.png");

    bool get canOpenAgora => isLive && !isEnded;

    bool get canOpenRecording => isEnded && canPlayRecording && hasValidFile;

    factory Session.fromJson(Map<dynamic, dynamic> json) {
        return Session(
            date: _toDate(json["date"]),
            channelName: json["channel_name"]?.toString() ?? "",
            courseId: _toInt(json["course_id"]),
            file: json["file"]?.toString() ?? "",
            isFree: _toBool(json["is_free"]),
            description: json["description"]?.toString() ?? "",
            id: _toInt(json["id"]),
            title: json["title"]?.toString() ?? "",
            type: json["type"]?.toString() ?? "",
            toTime: json["to_time"]?.toString() ?? "",
            fromTime: json["from_time"]?.toString() ?? "",
            status: json["status"]?.toString() ?? "",
            canPlayRecording: _toBool(json["can_play_recording"]),
        );
    }

    Map<dynamic, dynamic> toJson() => {
        "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
        "status": status,
        "can_play_recording": canPlayRecording,
    };
}

int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
}

bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;

    final text = value.toString().toLowerCase().trim();

    return text == "1" || text == "true" || text == "yes";
}

DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();

    return DateTime.tryParse(value.toString()) ?? DateTime.now();
}