import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/coachOrderDetailsModel.dart';
import 'package:gymatvendor/data/models/gymOrderDetailsModel.dart';
import 'package:gymatvendor/data/models/spaOrderDetailsModel.dart';
import 'package:gymatvendor/data/models/sportsFieldOrderDetailsModel.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_home_provider.dart';
import 'package:gymatvendor/presentations/gym_module/gymReceiptDetailsScreen/gymReceiptDetailsScreen.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_home_provider.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/provider/healthyclub_spa_home_provider.dart';
import 'package:gymatvendor/presentations/healthy_food_module/provider/healthy_food_home_provider.dart';
import 'package:gymatvendor/presentations/sport_field_module/provider/sports_field_home_provider.dart';
import 'package:gymatvendor/presentations/sport_field_module/sportsFieldReceiptDetailsScreen/sportsFieldReceiptDetailsScreen.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../../data/models/foodOrderDetailsModel.dart';
import '../../data/models/shopOrderDetailsModel.dart';
import '../../injection.dart';
import '../coaches_workout_module/coachReceiptDetailsScreen/coachReceiptDetailsScreen.dart';
import '../healthcub_spa_module/spaReceiptDetailsScreen/spaReceiptDetailsScreen.dart';
import '../healthy_food_module/foodReceiptDetailsScreen/foodReceiptDetailsScreen.dart';
import '../shop_module/provider/shop_home_provider.dart';
import '../shop_module/shop_receipt_details_screen/shopReceiptDetailsScreen.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  GlobalKey qrKey = GlobalKey(debugLabel: 'Qr');

  QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Qr code scanner'.tr(),
    elevation: 1,
    bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
    ),
    body: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated,overlay:QrScannerOverlayShape(borderRadius: 12,borderColor: Colors.red,),formatsAllowed: const [BarcodeFormat.qrcode],));
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((event) async{
     String? code = event.code;
     RegExp regExp = RegExp(r'^[0-9]+$');
     if(code!=null&&regExp.hasMatch(code)){
       controller.stopCamera();
       Preferences preferences = Preferences();
       UserModel? userModel = preferences.getUserData();
       if(userModel!=null){
         if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.gym.name){
           scannGymData(code);
         }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.healthClubAndSpa.name){
           scannSpaData(code);
         }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.healthyFood.name){
           scannFoodData(code);
         }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.coache.name){
           scannCoachData(code);
         }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.market.name){
           scannShopData(code);

         }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.sportFieldRentals.name){
           scannSportsFieldData(code);

         }
       }

     }else{
       CustomScaffoldMessanger.showToast(title: 'Invalid receipt code'.tr());
       controller.stopCamera();
       await Future.delayed(const Duration(seconds: 2));
       controller.resumeCamera();

     }
    });

  }

  void scannGymData(String code) async{
    GymHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        GymOrderDetailsModel model = GymOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(GymReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }
  }
  void scannSpaData(String code) async{
    HealthyClubSpaHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        SpaOrderDetailsModel model = SpaOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(SpaReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }

  }
  void scannFoodData(String code) async{
    HealthyFoodHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        FoodOrderDetailsModel model = FoodOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(FoodReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }

  }
  void scannCoachData(String code) async {
    CoachHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        CoachOrderDetailsModel model = CoachOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(CoachReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }


  }
  void scannShopData(String code) async{

    ShopHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        ShopOrderDetailsModel model = ShopOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(ShopReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }

  }
  void scannSportsFieldData(String code) async{
    SportsFieldHomeProvider provider = getIt();
    ApiResponse apiResponse = await provider.scanQrCode(num.parse(code));
    if(apiResponse.response?.statusCode==200){
      if(apiResponse.code==200){
        SportsFieldOrderDetailsModel model = SportsFieldOrderDetailsModel.fromJson(apiResponse.response?.data['data']);
        NavigatorHandler.pushReplacement(SportsFieldReceiptDetailsScreen(model: model));

      }else if(apiResponse.code==422){
        controller?.resumeCamera();
        showErrorSheetNoReceitFound();
      }
    }else{
      controller?.resumeCamera();
    }
  }

  
  void showErrorSheetNoReceitFound(){
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
        builder: (context){
      return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(title: 'E-Receipt'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 22,),
                InkWell(
                    onTap: (){
                      NavigatorHandler.pop();
                    },
                    child: CustomSvgIcon(assetName: 'close'.tr(),color: AppTheme.isDarkMode()?Colors.white:Colors.black,))
              ],
            ),
          ),
          const SizedBox(height: 12,),
          Divider(color: AppTheme.isDarkMode()
              ? inputBgDark.withOpacity(.6)
              : inputBg,),
          const SizedBox(height: 24,),
          const CustomSvgIcon(assetName: 'error_mark',width: 48,height: 48,color: Colors.red,),
          const SizedBox(height: 16,),
          Container(
              constraints: const BoxConstraints(maxWidth: 220),
              alignment: Alignment.center,
              child: CustomText(title: 'This E-Receipt doesnt exist. It is possible for someone else'.tr(),textAlign: TextAlign.center,fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
          const SizedBox(height: 16,),
          InkWell(
            onTap: (){
              controller?.resumeCamera();
              NavigatorHandler.pop();
            },
            child: Container(
              width: 140,
              decoration: BoxDecoration(color: AppTheme.isDarkMode()?dark:inputBg,borderRadius: BorderRadius.circular(36)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              child: Row(
                children: [
                  CustomSvgIcon(assetName: 'reload',color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  const SizedBox(width: 8,),
                  CustomText(title: 'Try again'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,)
                ],
              ),
            ),
          ),
          const SizedBox(height: 24,),

        ],
      );
    });
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if(Platform.isAndroid){
      controller?.pauseCamera();
    }else if(Platform.isIOS){
      controller?.resumeCamera();
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

}
