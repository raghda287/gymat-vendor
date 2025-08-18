import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/socketProvider.dart';

import '../../../data/models/user_model.dart';
import '../../../injection.dart';
import 'account_item_widget.dart';

class ChooseMainAccountWidget extends StatefulWidget {
  const ChooseMainAccountWidget({super.key});

  @override
  State<ChooseMainAccountWidget> createState() => _ChooseMainAccountWidgetState();
}

class _ChooseMainAccountWidgetState extends State<ChooseMainAccountWidget> {
  late List<AccountsModel> accounts ;
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    UserModel? userModel = Preferences().getUserData();
    accounts = [];
    selectedIndex = -1;

    if(userModel!=null&&userModel.providerModel!=null&&userModel.providerModel!.mainAccount!=null){
      accounts = userModel.providerModel!.accounts;

      for(int index = 0;index<accounts.length;index++){
        AccountsModel model = accounts[index];
        if(model.id==userModel.providerModel!.mainAccount!.id){
          selectedIndex = index;
          break;
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 24,),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(color: AppTheme.isDarkMode()?greyColor.withOpacity(.2):greyColor.withOpacity(.2),borderRadius: BorderRadius.circular(3)),

          ),
          const SizedBox(height: 12,),
          Expanded(
              child: ListView.builder(
              itemCount: accounts.length,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      ProfileProvider provider = getIt();
                      bool  response = await provider.updateMainAccount(accounts[index]);
                      if(response){
                        NavigatorHandler.pop();
                        Widget? screen = NavigatorHandler().getHomeScreen();

                        if(screen!=null){

                          SocketProvider soketProvider = getIt();
                          soketProvider.disconnectToSocket();
                          soketProvider.connectToSocket();

                          await Future.delayed(const Duration(milliseconds: 200));
                          NavigatorHandler.pushAndRemoveUntil(screen);

                        }
                        
                      }

                    },
                    child: AccountItemWidget(accountsModel: accounts[index], selected: index==selectedIndex,));
              }))
        ],
      ),
    );
  }
}
