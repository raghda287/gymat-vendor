import 'dart:convert';

JoinSessionResponse joinSessionResponseFromJson(String str) => JoinSessionResponse.fromJson(json.decode(str));

String joinSessionResponseToJson(JoinSessionResponse data) => json.encode(data.toJson());

class JoinSessionResponse {
    JoinSessionResponse({
        required this.channelName,
        required this.role,
        required this.userId,
        required this.rtcToken,
        required this.sessionId,
        required this.expireAt,
        required this.type,
    });

    String channelName;
    String role;
    int userId;
    String rtcToken;
    int sessionId;
    int expireAt;
    String type;

    factory JoinSessionResponse.fromJson(Map<dynamic, dynamic> json) => JoinSessionResponse(
        channelName: json["channel_name"],
        role: json["role"],
        userId: json["user_id"],
        rtcToken: json["rtc_token"],
        sessionId: json["session_id"],
        expireAt: json["expire_at"],
        type: json["type"],
    );

    Map<dynamic, dynamic> toJson() => {
        "channel_name": channelName,
        "role": role,
        "user_id": userId,
        "rtc_token": rtcToken,
        "session_id": sessionId,
        "expire_at": expireAt,
        "type": type,
    };
}
