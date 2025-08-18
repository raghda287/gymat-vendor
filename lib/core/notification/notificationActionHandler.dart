import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/chatNotificationHandler.dart';
import 'package:gymatvendor/data/models/localNotificationHandler.dart';
import 'package:gymatvendor/data/models/roomModel.dart';
import 'package:gymatvendor/presentations/notification_screen/notificationScreen.dart';

import '../../data/models/userChatModel.dart';
import '../../data/models/user_model.dart';
import '../../injection.dart';
import '../../presentations/chat_module/chat_screen/chat_screen.dart';
import '../../socketProvider.dart';

enum NotificationType { notification, message }

class NotificationActionHandler {

  static void actionHandler(RemoteMessage? remoteMessage, [bool? isBackground]) async {
    if (remoteMessage != null) {
      print('notification payload: ${remoteMessage.data}');

      String? notiType = remoteMessage.data['noti_type'];
      String? marketId = remoteMessage.data['market_id'];
      Preferences preferences = Preferences();
      AccountsModel? account = preferences.getMainAccount();

      if (marketId != null && account != null) {
        if (marketId == account.id!.toString()) {
          if (notiType == 'follow' ||
              notiType == 'favorite' ||
              notiType == 'order' ||
              notiType == 'chat') {
            UserChatModel? chatUser;

            if (notiType == 'chat') {
              if (remoteMessage.data['room'] != null) {
                RoomModel roomModel =
                    RoomModel.fromJson(jsonDecode(remoteMessage.data['room']));
                chatUser = UserChatModel(
                    roomModel.user_id!,
                    roomModel.user?.user?.name,
                    roomModel.user?.user?.photo,
                    roomModel.id!);
              }
            }

            if (isBackground == true) {
              LocalNotificationHandler localNotificationHandler =
                  LocalNotificationHandler(
                      notiType == 'chat'
                          ? NotificationType.message
                          : NotificationType.notification,
                      chatUser);

              Widget? screen =
                  NavigatorHandler().getHomeScreen(localNotificationHandler);
              if (screen != null) {
                SocketProvider soketProvider = getIt();
                soketProvider.disconnectToSocket();
                soketProvider.connectToSocket();
                await Future.delayed(const Duration(milliseconds: 200));
                NavigatorHandler.pushAndRemoveUntil(screen);
              }
            } else {
              if (notiType == 'chat' && chatUser != null) {
                if (remoteMessage.data['room'] != null) {
                  RoomModel roomModel = RoomModel.fromJson(
                      jsonDecode(remoteMessage.data['room']));

                  Preferences preferences = Preferences();
                  ChatNotificationHandler? chatNotificationHandler =
                      preferences.getChatNotificationData();
                  if (chatNotificationHandler == null) {
                    NavigatorHandler.push(ChatScreen(chatUser: chatUser));
                  } else {
                    if (chatNotificationHandler.roomId == roomModel.id &&
                        roomModel.id != null) {
                      NavigatorHandler.pushReplacement(
                          ChatScreen(chatUser: chatUser));
                    }
                  }
                }
              } else {
                NavigatorHandler.push(const NotificationScreen());
              }
            }
          }
        } else {
          AccountsModel? account = await _getAccountById(int.parse(marketId));
          if (account != null) {
            bool result = await _updateMainAccount(account);
            if (result) {
              UserChatModel? chatUser;

              if (notiType == 'chat') {
                if (remoteMessage.data['room'] != null) {
                  RoomModel roomModel = RoomModel.fromJson(
                      jsonDecode(remoteMessage.data['room']));
                  chatUser = UserChatModel(
                      roomModel.user_id!,
                      roomModel.user?.user?.name,
                      roomModel.user?.user?.photo,
                      roomModel.id!);
                }
              }

              Widget? screen = NavigatorHandler().getHomeScreen(
                  LocalNotificationHandler(
                      notiType == 'chat'
                          ? NotificationType.message
                          : NotificationType.notification,
                      chatUser));
              if (screen != null) {
                SocketProvider soketProvider = getIt();
                soketProvider.disconnectToSocket();
                soketProvider.connectToSocket();
                await Future.delayed(const Duration(milliseconds: 200));
                NavigatorHandler.pushAndRemoveUntil(screen);
              }
            }
          }
        }
      }
    }
  }

  static Future<bool> _updateMainAccount(AccountsModel account) async {
    Preferences preferences = Preferences();
    UserModel? userModel = preferences.getUserData();
    if (userModel != null && userModel.providerModel != null) {
      userModel.providerModel!.mainAccount = account;
      Preferences().saveUserData(userModel);
      return true;
    }
    return false;
  }

  static Future<AccountsModel?> _getAccountById(num accountId) async {
    Preferences preferences = Preferences();
    UserModel? userModel = preferences.getUserData();
    if (userModel != null && userModel.providerModel != null) {
      for (AccountsModel accountsModel in userModel.providerModel!.accounts) {
        if (accountsModel.id == accountId) {
          return accountsModel;
        }
      }
    }
    return null;
  }
}
