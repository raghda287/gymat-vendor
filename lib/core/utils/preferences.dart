import 'dart:convert';
import 'package:gymatvendor/data/models/chatNotificationHandler.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  void saveUserData(UserModel userModel) {
    SharedPreferences sharedPreferences = getIt();
    String encodeString = jsonEncode(userModel.toJson());
    if(userModel.providerModel!=null){
      if(userModel.providerModel!.mainAccount!=null){
        saveMainAccount(userModel.providerModel!.mainAccount!);

      }else{
        saveMainAccount(userModel.providerModel!.accounts[0]);

      }

    }
    sharedPreferences.setString('user', encodeString);
  }

  void saveFirebaseToken(String? token) {
    SharedPreferences sharedPreferences = getIt();
    sharedPreferences.setString('firebaseToken', token??'');
  }

  String? getFirebaseToken() {
    SharedPreferences sharedPreferences = getIt();
    return sharedPreferences.getString('firebaseToken');
  }


  UserModel? getUserData() {
    SharedPreferences sharedPreferences = getIt();
    if (sharedPreferences.containsKey('user') &&
        sharedPreferences.getString('user') != null) {
      UserModel userModel = UserModel.fromJson(jsonDecode(sharedPreferences.getString('user')!));

      userModel.providerModel!.mainAccount = getMainAccount();
      return userModel;
    }
    return null;
  }

  void logout() async{
    SharedPreferences sharedPreferences = getIt();
    await sharedPreferences.remove('user');
    await sharedPreferences.remove('firebaseToken');
    await sharedPreferences.remove('chatNotificationData');

  }

  void saveMainAccount(AccountsModel mainAccount) {
    SharedPreferences sharedPreferences = getIt();
    String encodeMainAccountString = jsonEncode(mainAccount.toJson());
    sharedPreferences.setString('main_account', encodeMainAccountString);
  }

  AccountsModel? getMainAccount() {
    SharedPreferences sharedPreferences = getIt();
    if (sharedPreferences.containsKey('main_account') &&
        sharedPreferences.getString('main_account') != null) {
      AccountsModel? accountsModel = AccountsModel.fromJson(
          jsonDecode(sharedPreferences.getString('main_account')!));
      return accountsModel;
    }
    return null;
  }

  bool isDarkMode() {
    SharedPreferences sharedPreferences = getIt();
    bool? isDarkMode = sharedPreferences.getBool('isDarkMode');
    return isDarkMode ?? false;
  }



  void saveIsDarkMode(bool isDarkMode) async {
    SharedPreferences sharedPreferences = getIt();
    await sharedPreferences.setBool('isDarkMode', isDarkMode);
  }



  void saveChatNotificationData(ChatNotificationHandler handler) {
    SharedPreferences sharedPreferences = getIt();
    String encodeString = jsonEncode(handler.toJson());
    sharedPreferences.setString('chatNotificationData', encodeString);

  }

  ChatNotificationHandler? getChatNotificationData() {
    SharedPreferences sharedPreferences = getIt();
    if (sharedPreferences.containsKey('chatNotificationData') && sharedPreferences.getString('chatNotificationData') != null) {
      ChatNotificationHandler? handler = ChatNotificationHandler.fromJson(jsonDecode(sharedPreferences.getString('chatNotificationData')!));
      return handler;
    }
    return null;
  }

  void clearChatNotificationData() async{
    SharedPreferences sharedPreferences = getIt();
    await sharedPreferences.remove('chatNotificationData');

  }

}
