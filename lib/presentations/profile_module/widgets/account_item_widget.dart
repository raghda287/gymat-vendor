import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class AccountItemWidget extends StatelessWidget {
  final AccountsModel accountsModel;
  final bool selected;
  const AccountItemWidget({super.key, required this.accountsModel, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            children: [
              Center(child: CustomAvatar(url: accountsModel.logo!=null?accountsModel.logo!.contains('default-img')?getAvatarAssets(accountsModel):accountsModel.logo:'',borderWidth: 0.5,borderColor:AppTheme.isDarkMode() ? inputBgDark.withOpacity(.6) : greyColor.withOpacity(0.2),radius: 42,placeHolderWidget:CustomAssetImage(assetName: getAvatarAssets(accountsModel)),)),
              Container(
                width: 22,
                height: 22,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: mainColor,shape: BoxShape.circle,border: Border.all(color: mainColor,width: 0.2)),
                alignment: Alignment.center,
                child: CustomSvgIcon(assetName: getAvatarIcon(accountsModel),color: Colors.white,),
              )
            ],
          ),
        ),
        const SizedBox(width: 12,),
        SizedBox(
          width: 150,
          child: CustomText(title: accountsModel.business_name ?? accountsModel.category.title??'',fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,maxLines: 1,),
        ),
        const Expanded(child: SizedBox()),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: selected?mainColor:Colors.transparent,width: selected?6:0)),
        )
      ],),
    );
  }
  String getAvatarAssets(AccountsModel accountsModel){

    if(accountsModel.category.type==USERTYPE.gym.name){
      return 'assets/images/icons/gym_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.coache.name){
      return 'assets/images/icons/coach_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.healthClubAndSpa.name){
      return 'assets/images/icons/spa_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.healthyFood.name){
      return 'assets/images/icons/food_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.market.name){
      return 'assets/images/icons/shop_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.sportFieldRentals.name){
      return 'assets/images/icons/sport_field_avatar.png';
    }

    return '';
  }

  String getAvatarIcon(AccountsModel accountsModel){

    if(accountsModel.category.type==USERTYPE.gym.name){
      return 'gym_icon';
    }else if(accountsModel.category.type==USERTYPE.coache.name){
      return 'coach_icon';
    }else if(accountsModel.category.type==USERTYPE.healthClubAndSpa.name){
      return 'spa_icon';
    }else if(accountsModel.category.type==USERTYPE.healthyFood.name){
      return 'food_icon';
    }else if(accountsModel.category.type==USERTYPE.market.name){
      return 'market_icon';
    }else if(accountsModel.category.type==USERTYPE.sportFieldRentals.name){
      return 'playground';
    }

    return '';
  }

}
