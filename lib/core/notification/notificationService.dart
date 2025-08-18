import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymatvendor/core/notification/notificationActionHandler.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/chatNotificationHandler.dart';

import '../../data/models/roomModel.dart';

class NotificationService{
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void init() async{
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(NotificationService.firebaseMessagingForegroundHandler);


  }

  static Future<void> _displayNotification(RemoteMessage? message) async {
    if (message!.notification != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('gymatvendor_id', 'gymatvendor',
          icon: 'ic_launcher',
          channelDescription: 'Gymat vendor app notification',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          sound: null);

      FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
      NotificationService.flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          );


      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

      plugin.initialize(initializationSettings,

          onDidReceiveNotificationResponse: (response) {
            onDidReceiveNotificationResponse(response, message);
          });

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: DarwinNotificationDetails());

      await plugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: message.data.toString());
    }
  }

  @pragma('vm:entry-point')
  static Future<void>  firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
    print("background_____${message!.data}");
    await Firebase.initializeApp();

  }

  static Future<void> firebaseMessagingForegroundHandler(RemoteMessage? remoteMessage) async {
    print("forground__________${remoteMessage?.data}");

    if(remoteMessage!=null){
      String? notiType = remoteMessage.data['noti_type'];
      if(notiType=='chat') {


        if(remoteMessage.data['room']!=null){
          RoomModel roomModel = RoomModel.fromJson(jsonDecode(remoteMessage.data['room']));
          Preferences preferences = Preferences();
         ChatNotificationHandler? chatNotificationHandler =  preferences.getChatNotificationData();

         if(chatNotificationHandler!=null){
           if(chatNotificationHandler.roomId==roomModel.id&&roomModel.id!=null){
             if(chatNotificationHandler.showNotification == true){
               _displayNotification(remoteMessage);
             }
           }else{
             _displayNotification(remoteMessage);
           }
         }else{
           _displayNotification(remoteMessage);
         }


        }
      }

      else{
        _displayNotification(remoteMessage);

      }
    }



  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse, RemoteMessage? remoteMessage) async {
    print('data->>>${remoteMessage?.data}');
   NotificationActionHandler.actionHandler(remoteMessage);
  }


}