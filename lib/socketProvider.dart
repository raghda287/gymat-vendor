import 'dart:convert';

import 'package:gymatvendor/data/models/roomModel.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/models/messageModel.dart';
import '../injection.dart';
import 'core/app_url/app_url.dart';
import 'data/models/user_model.dart';


class SocketProvider {
  IO.Socket? socket;
  Set<num> ids = {};

  void _init(){
    socket ??= IO.io(AppUrls.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
  }

  void connectToSocket() {

    if(socket==null){
      _init();
    }

    socket!.connect();
    socket!.onConnect((data) async {
      print('onConnect=>>> success');
      joinToMarket();
      ChatProvider chatProvider = getIt();

      List<int> ids = await chatProvider.getAllRoomsIds();
      if(ids.isNotEmpty){
        joinToAllRooms(ids);

      }


    });

    socket!.onDisconnect((data) {
      print('onDisConnect=>>>$data');
    });

    socket!.onConnectError((data) {
      print('onConnectError=>>>$data');
      connectToSocket();
    });


    listenToNewMessage();

  }

  void disconnectToSocket() {


    if(socket==null||socket!.disconnected){
      return;
    }

    leaveAllRooms();

    socket!.disconnect();

    socket = null;
    ids = {};
  }



  void joinToAllRooms(List<num> ids) {
    this.ids = Set.of(ids);

    if (socket != null ) {
      String roomsIdsArray = jsonEncode(ids);
      socket!.emit(AppUrls.socketJoinRooms, roomsIdsArray);
      print('joinedToRooms=>>>>${ids.toList().join(',')} = Success');
    }
  }

  void leaveAllRooms(){
    if(ids.isNotEmpty){
      if (socket != null ) {
        String roomsIdsArray = jsonEncode(ids.toList());
        socket!.emit(AppUrls.socketLeaveRooms, roomsIdsArray);
        print('disJoinedFromRooms');
      }
    }

  }


  void joinToRoom(num id){
    if (socket != null ) {

      List<num> ids = [];
      ids.add(id);
      this.ids.add(id);

      socket!.emit(AppUrls.socketJoinRooms, jsonEncode(ids));


      print('joinedto=>>room=>$id = success');
    }
  }

  void joinToMarket() {
    ProfileProvider profileProvider = getIt();
    UserModel? userModel = profileProvider.getUserModel();
    if(userModel==null){
      return;
    }
    if (socket != null ) {
      socket!.emit(AppUrls.socketJoinMarket, jsonEncode(userModel.providerModel!.mainAccount!.id!));
      print('joinedToMarket');

    }

  }

  void sendMessageUserLevel(RoomModel room){
    if (socket != null ) {
      joinToRoom(room.id!);

      String data = jsonEncode(room.toJson());
      socket!.emit(AppUrls.socketSendFirstMessage, data);
      print('sendFirstMessage=>>success');
    }
  }
  void sendMessageRoomLevel(MessageModel messageModel){
    if (socket != null ) {
      String roomsIdsArray = jsonEncode(messageModel.toJson());
      socket!.emit(AppUrls.socketSendMessage, roomsIdsArray);
      print('sendMessage=>>success');
    }
  }

  void listenToNewMessage() {

    print('rttttt');

    if (socket != null) {

      socket!.onAny((event, data){
        print('dataListeners=>>>${event}=>>>>>>>${data}');


      });

      ChatProvider chatProvider = getIt();
      socket!.on(AppUrls.socketReceiveFirstMessage, (data) async{
        print('firstMessage=>>>> listended');

        RoomModel roomModel = RoomModel.fromJson(data);
        joinToRoom(roomModel.id!);

        chatProvider.onNewMessage(roomModel.latest_message!);
        chatProvider.onNewRoomCreated(roomModel);
        print('message=>>$roomModel');

      });

      socket!.on(AppUrls.socketReceiveMessage, (data) {
        print('secondMessage=>>>> listended');

        MessageModel messageModel = MessageModel.fromJson(data);
        if(messageModel.sender=='user'){
          chatProvider.onNewMessage(messageModel);
          print('message=>>$messageModel');
        }


      });

    }
  }



}