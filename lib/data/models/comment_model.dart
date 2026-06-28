import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    CommentModel({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    List<CommentData> data;
    String message;

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        code: json["code"] ?? 0,
        data: json["data"] == null
            ? []
            : List<CommentData>.from(
            json["data"].map((x) => CommentData.fromJson(x)),
        ),
        message: json["message"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class CommentData {
    CommentData({
        required this.id,
        required this.comment,
        required this.user,
        required this.isMe,
    });

    int id;
    String comment;
    CommentUser user;
    bool isMe;

    factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"] ?? 0,
        comment: json["comment"] ?? '',
        user: CommentUser.fromJson(json["user"] ?? {}),
        isMe: json["is_me"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "user": user.toJson(),
        "is_me": isMe,
    };
}

class CommentUser {
    CommentUser({
        required this.id,
        required this.name,
        required this.photo,
    });

    int id;
    String name;
    String photo;

    factory CommentUser.fromJson(Map<String, dynamic> json) => CommentUser(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        photo: json["photo"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
    };
}