import 'package:gymatvendor/core/notification/notificationActionHandler.dart';
import 'package:gymatvendor/data/models/userChatModel.dart';

class LocalNotificationHandler{
  final NotificationType? notificationType;
  final UserChatModel? chatUser;

  LocalNotificationHandler(this.notificationType, this.chatUser);
}