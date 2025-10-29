
import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String chatModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    CommentModel({
        required this.code,
        required this.data,
        required this.message,
    });

    int code;
    List<CommentData> data;
    String message;

    factory CommentModel.fromJson(Map<dynamic, dynamic> json) => CommentModel(
        code: json["code"],
        data: List<CommentData>.from(json["data"].map((x) => CommentData.fromJson(x))),
        message: json["message"],
    );

    Map<dynamic, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class CommentData {
    CommentData({
        required this.comment,
        required this.id,
        required this.user,
    });

    String comment;
    int id;
    DatumUser user;

    factory CommentData.fromJson(Map<dynamic, dynamic> json) => CommentData(
        comment: json["comment"],
        id: json["id"],
        user: DatumUser.fromJson(json["user"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "comment": comment,
        "id": id,
        "user": user.toJson(),
    };
}

class DatumUser {
    DatumUser({
        required this.user,
    });

    UserUser user;

    factory DatumUser.fromJson(Map<dynamic, dynamic> json) => DatumUser(
        user: UserUser.fromJson(json["user"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class UserUser {
    UserUser({
        required this.wallet,
        required this.gender,
        required this.phone,
        required this.following,
        required this.name,
        required this.weight,
        required this.photo,
        required this.id,
        required this.type,
        required this.age,
        required this.phoneCode,
        required this.height,
    });

    int wallet;
    String gender;
    String phone;
    int following;
    String name;
    int weight;
    String photo;
    int id;
    String type;
    int age;
    String phoneCode;
    int height;

    factory UserUser.fromJson(Map<dynamic, dynamic> json) => UserUser(
        wallet: json["wallet"],
        gender: json["gender"],
        phone: json["phone"],
        following: json["following"],
        name: json["name"],
        weight: json["weight"],
        photo: json["photo"],
        id: json["id"],
        type: json["type"],
        age: json["age"],
        phoneCode: json["phone_code"],
        height: json["height"],
    );

    Map<dynamic, dynamic> toJson() => {
        "wallet": wallet,
        "gender": gender,
        "phone": phone,
        "following": following,
        "name": name,
        "weight": weight,
        "photo": photo,
        "id": id,
        "type": type,
        "age": age,
        "phone_code": phoneCode,
        "height": height,
    };
}
