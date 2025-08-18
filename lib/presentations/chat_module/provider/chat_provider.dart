import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/navigator/navigator.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/messageModel.dart';
import '../../../data/models/roomModel.dart';
import '../../../data/models/userChatModel.dart';
import '../../../data/models/userProfileModel.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../../socketProvider.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../chat_screen/chat_screen.dart';

class ChatProvider with ChangeNotifier{
  final ChatRepository repository = getIt();
  RoomModel? roomModel;
  List<MessageModel?> messages = [];
  bool isLoading = true;
  bool isLoadingRooms = true;
  bool isLoadingUserProfile = true;
  int page = 1;
  int pageMessage = 1;
  bool isLoadingMoreMessages = false;

  bool isLoadingMoreRooms = false;
  List<RoomModel?> rooms = [];

  int? selctedRoomIndex ;
  RoomModel? selectedRoom;

  //////////////////////////////////////////////////////
  UserProfileModel? userProfileModel;
  //////////////////////////////////////////////////////

  void initChat(){
    roomModel = null;
    messages.clear();
    isLoading = true;
    pageMessage = 1;
    isLoadingMoreMessages = false;
  }

  void initRooms(){
    isLoadingRooms = true;
    rooms =[];
    page = 1;
    isLoadingMoreRooms = false;
    selctedRoomIndex = null;
    selectedRoom = null;

  }

  void initUserProfile(){
    isLoadingUserProfile = true;
    userProfileModel = null;
  }
  void updateSelectedRoom(RoomModel roomModel,int? index){
    selectedRoom = roomModel;
    selctedRoomIndex = index;
  }

  Future<String?> pickImage(ImageSource source) async
  {
    String? filePath;
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 1024, imageQuality: 50);
    if (xFile != null) {
      filePath = xFile.path;
    }

    return filePath;
  }

  void createChatRoom(num userId, String? name, String? image,num? roomId) async
  {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Creating chat ...'.tr());

    try {

      if(roomId==null){
        await dialog.show();

      }else{
        isLoading = true;
        notifyListeners();
      }

      ApiResponse response = await repository.createAndGetMessages(userId);
      if(roomId==null){
        await dialog.hide();
        await Future.delayed(const Duration(milliseconds: 200));

      }else{
        isLoading = false;
        notifyListeners();
      }

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code ==200) {

              if(roomId==null){
                num? roomChatId = response.response?.data['data']['id'];
                if(roomChatId!=null){
                  UserChatModel userChatModel = UserChatModel(userId, name, image,roomChatId);
                  NavigatorHandler.push(ChatScreen(chatUser: userChatModel));
                }
              }else{
                roomModel = RoomModel.fromJson(response.response?.data['data']);
                if(roomModel!=null){
                  messages.clear();
                  messages.addAll(roomModel!.messages);

                }

                notifyListeners();
              }
            }
          } else {}
        } else {}
      }
    } catch (e) {
      if(roomId==null){
        await dialog.hide();

      }else{
        isLoading = true;
        notifyListeners();
      }
      print('errorGetCreateRoom=>>>>$e');
    }
  }


  void sendMessage(num? roomId,String type,String message,int seconds,num? aspectRatio) async
  {

    try {
      ApiResponse response = await repository.sendMessage(roomId,type,message,seconds,aspectRatio);
      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code==200) {
              MessageModel message = MessageModel.fromJson(response.response!.data['data']['message']);
              messages.insert(0,message);

              bool? isFirstMessage = response.response!.data['data']['first_message'];
              SocketProvider socketProvider = getIt();


              if(isFirstMessage!=null&&!isFirstMessage){
                socketProvider.sendMessageRoomLevel(message);


              }


              if(roomModel!=null){
                roomModel!.latest_message = message;

                if(selctedRoomIndex!=null){
                  rooms[selctedRoomIndex!] = roomModel;
                  sortRooms();

                }


                if(isFirstMessage!=null&&isFirstMessage){
                  socketProvider.sendMessageUserLevel(roomModel!);

                }
              }

              notifyListeners();
            }
          } else {}
        } else {}
      }
    } catch (e) {

      print('errorSendMessage=>>>>$e');
    }
  }

  void getRooms() async
  {
    isLoadingRooms = true;
    rooms.clear();
    notifyListeners();

    try {

      ApiResponse response = await repository.getRooms(1);
      isLoadingRooms = false;
      notifyListeners();


      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if(response.code==200) {
              response.response!.data['data'].forEach((v)=>rooms.add(RoomModel.fromJson(v)));
              sortRooms();

              notifyListeners();
            }
          } else {}
        } else {}
      }
    } catch (e) {
      print('errorGetRooms=>>>>$e');
    }
  }


  void loadMoreRooms() async
  {
    isLoadingMoreRooms = true;
    rooms.add(null);
    notifyListeners();
    int p = page+1;


    try {

      ApiResponse response = await repository.getRooms(p);
      isLoadingMoreRooms = false;
      notifyListeners();


      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if(response.code==200) {
              if(rooms.last==null){
                rooms.removeLast();
              }

              List<RoomModel> rList = [];
              response.response!.data['data'].forEach((v)=>rList.add(RoomModel.fromJson(v)));

              if(rList.isNotEmpty){
                page = p;
              }

              rooms.addAll(rList);
              notifyListeners();

            }
          } else {}
        } else {}
      }
    } catch (e) {
      isLoadingMoreRooms = false;
      if(rooms.last==null){
        rooms.removeLast();
      }
      notifyListeners();
      print('errorLoadMoreRooms=>>>>$e');
    }
  }

  void loadMoreMessages() async
  {
    isLoadingMoreMessages= true;
    messages.add(null);
    notifyListeners();
    int p = pageMessage+1;


    try {

      ApiResponse response = await repository.loadMoreMessages(p,roomModel?.id);
      isLoadingMoreMessages = false;
      notifyListeners();


      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if(response.code==200) {
              if(messages.last==null){
                messages.removeLast();
              }

              List<MessageModel> rList = [];
              response.response!.data['data'].forEach((v)=>rList.add(MessageModel.fromJson(v)));

              if(rList.isNotEmpty){
                page = p;
              }

              messages.addAll(rList.reversed);
              notifyListeners();

            }
          } else {}
        } else {}
      }
    } catch (e) {
      isLoadingMoreMessages = false;
      if(messages.last==null){
        messages.removeLast();
      }
      notifyListeners();
      print('errorLoadMoreMEssage=>>>>$e');
    }
  }


  void createChatVideoUrl(num? roomId,num? userId) async
  {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Creating video call link ...'.tr());

    try {
      await dialog.show();

      ApiResponse response = await repository.createVideoChatUrl(userId);
      await dialog.hide();


      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code ==200) {
              String? url = response.response?.data['data']['url'];
              if(url!=null&&url.isNotEmpty){

                sendMessage(roomId, 'text', url, 0, null);
              }
            }
          } else {}
        } else {}
      }else{
        await dialog.hide();

      }
    } catch (e) {
      await dialog.hide();
      print('error create video url=>>>>$e');
    }
  }


  void getUserProfile(num? userId) async{
    isLoadingUserProfile = true;
    notifyListeners();

    try {
      String date = DateFormat('yyyy-MM-dd','en').format(DateTime.now());

      ApiResponse response = await repository.getUserProfile(userId,date);
      isLoadingUserProfile = false;
      notifyListeners();


      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if(response.code==200) {
              userProfileModel = UserProfileModel.fromJson(response.response?.data['data']);
              notifyListeners();
            }
          } else {}
        } else {}
      }
    } catch (e) {
      isLoadingUserProfile = false;
      notifyListeners();
      print('errorGetUserProfile=>>>>$e');
    }
  }


  Future<List<int>> getAllRoomsIds() async{
    ProfileProvider profileProvider = getIt();
    UserModel? userModel = profileProvider.getUserModel();
    if(userModel==null){
      return [];
    }

    try{
      ApiResponse response = await repository.getAllRoomsIds();
      if(response.response!=null){
        if(response.response!.statusCode==200||response.response!.statusCode==201){
          if(response.response!.data!=null&&response.response!.data['data']!=null){

            if(response.code ==200){
              List<int> ids = [];
              response.response!.data['data'].forEach((v)=>ids.add(v));
              return ids;
            }
          }else{

          }
        }else{

        }
      }
    }catch (e){
      print('errorGetAllRoomsData=>>>${e}');
      return [];
    }
    return [];


  }


  void sortRooms() {
    rooms.sort((a,b){
      if(a!=null&&b!=null&&a.latest_message!=null&&b.latest_message!=null){
        if(a.latest_message!.timestamp! > b.latest_message!.timestamp!){
          return -1;
        } else  if(a.latest_message!.timestamp! < b.latest_message!.timestamp!){
          return 1;
        }else{
          return 0;
        }
      }

      return 0;
    });
  }

  void onNewMessage(MessageModel messageModel){

    if(selectedRoom!=null){
      if(selectedRoom!.id == messageModel.room_id &&selectedRoom!.id !=null){
        messages.insert(0,messageModel);
        notifyListeners();
      }
    }else{
      messages.insert(0,messageModel);
      notifyListeners();
    }


    print('roomLength=>>>${rooms.length}');

    for(int index = 0;index<rooms.length;index++){
      RoomModel? roomModel = rooms[index];
      print('roomsMessage=>>>${roomModel?.id}----${messageModel.room_id}');

      if(roomModel!=null&&roomModel.id == messageModel.room_id&&roomModel.id!=null){
        roomModel.latest_message = messageModel;
        rooms[index] = roomModel;
        sortRooms();
        notifyListeners();
      }
    }




  }

  void onNewRoomCreated(RoomModel roomModel){
    selectedRoom ??= roomModel;
    rooms.add(roomModel);
    sortRooms();
    notifyListeners();
  }

}