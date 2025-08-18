import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/ad_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/data/models/paymentResponse.dart';
import 'package:gymatvendor/data/repositories/ad_repository.dart';
import 'package:gymatvendor/presentations/payment_module/webview_payment/webview_payment.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/payment/choose_payment_type_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/app_theme/theme.dart';
import '../../../data/models/api_response.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/payment/payment_sheets.dart';

enum OrderOrAd { ad, order }

class AdProvider with ChangeNotifier {
  AdRepository repository = getIt();

  String? adPhoto;
  int? showAdWhere;
  String? startDate;
  String? endDate;
  DateTime? fromTime;
  DateTime? toTime;
  TextEditingController secondsController = TextEditingController();
  LocationModel? adLocation;

  ////////my ads//////////////////
  int selectedIndex = 0;
  bool isLoadingAds = false;
  bool isLoadingAdDetails = false;
  List<AdModel> myAdsList = [];
  AdModel? adDetails;
  CancelToken? cancelToken;

  void init() {
    adPhoto = null;
    showAdWhere = null;
    fromTime = null;
    toTime = null;
    secondsController.clear();
    cancelToken = null;
    adLocation = null;
  }

  void initMyAds() {
    selectedIndex = 0;
    isLoadingAds = false;
    myAdsList = [];
  }


  void pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 1024, imageQuality: 50);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor:
                AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            lockAspectRatio: true,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
              title: 'Cropper',
              minimumAspectRatio: 16 / 9,
              aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          ),

        ],
      );

      if (croppedFile != null) {
        adPhoto = croppedFile.path;

        notifyListeners();
      }
    }
  }

  bool isOldDate(String expDate) {
    String exDate = '01/$expDate}';
    DateTime dateFormat = DateFormat('dd/MM/yyyy', 'en').parse(exDate);
    DateTime cardDate = DateTime.parse(dateFormat.toString());

    DateTime now = DateTime.now();

    return cardDate.isBefore(now);
  }

  Future<bool> payForAd(String orderOrAd, String paymentType, String cardName,
      String cardNumber, String month, String year, String cvv) async {
    return true;
  }

  void updateShowAdWhere(int value) {
    showAdWhere = value;
  }

  void updateSelectedRangeDate(String? startDate, String? endDate) {
    this.startDate = startDate;
    this.endDate = endDate;
  }

  void updateFromTime(DateTime? fromTime) {
    this.fromTime = fromTime;
    notifyListeners();
  }

  void updateToTime(DateTime? toTime) {
    this.toTime = toTime;
    notifyListeners();
  }

  Future<bool> checkPayment(
      String orderOrAd,
      String? discountCode,
      String paymentType,
      String cardName,
      String cardNumber,
      String month,
      String year,
      String cvv) async
  {
    CreditCardValidator cardValidator = CreditCardValidator();
    cardNumber = cardNumber.replaceAll(' ', '');
    cardNumber = cardNumber.replaceAll('-', '');

    CCNumValidationResults cardNumberResult =
        cardValidator.validateCCNum(cardNumber);
    ValidationResults cardExDateResult =
        cardValidator.validateExpDate('$month/$year');

    if (cardName.length >= 2 &&
        cvv.length == 3 &&
        cardNumberResult.isValid &&
        cardExDateResult.isValid &&
        !isOldDate('$month/$year')) {
      if (orderOrAd == OrderOrAd.ad.name) {
        return payForAd(
            orderOrAd, paymentType, cardName, cardNumber, month, year, cvv);
      } else {
        return true;
      }
    } else if (cardName.length < 2) {
      CustomScaffoldMessanger.showToast(title: 'Invalid holder name'.tr());
      return false;
    } else if (!cardNumberResult.isValid) {
      CustomScaffoldMessanger.showToast(title: 'Invalid card number'.tr());
      return false;
    } else if (!cardExDateResult.isValid || isOldDate('$month/$year')) {
      CustomScaffoldMessanger.showToast(title: 'Invalid expire date'.tr());
      return false;
    } else {
      return false;
    }
  }

  bool checkAddAdData() {
    if (adPhoto != null &&
        showAdWhere != null &&
        startDate != null &&
        endDate != null &&
        adLocation != null) {
      return true;
    } else {
      if (adPhoto == null) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Photo of ad required'.tr(),
            bg: Colors.red,
            fontColor: Colors.white);
      }

      if (showAdWhere == null) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Choose where ad show'.tr(),
            bg: Colors.red,
            fontColor: Colors.white);
      }
      if (startDate == null) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Select start date of ad'.tr(),
            bg: Colors.red,
            fontColor: Colors.white);
      }
      if (endDate == null) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Select end date of ad'.tr(),
            bg: Colors.red,
            fontColor: Colors.white);
      }

      if (adLocation == null) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Select ad location'.tr(),
            bg: Colors.red,
            fontColor: Colors.white);
      }
      return false;
    }

    /*if(adPhoto!=null&&showAdWhere!=null&&startDate!=null&&endDate!=null&&fromTime!=null&&toTime!=null&&secondsController.text.trim().isNotEmpty){

      return true;

    }else{
      if(adPhoto==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Photo of ad required'.tr(),bg: Colors.red,fontColor: Colors.white);
      }

      if(showAdWhere==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Choose where ad show'.tr(),bg: Colors.red,fontColor: Colors.white);

      }
      if(startDate==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Select start date of ad'.tr(),bg: Colors.red,fontColor: Colors.white);

      }
      if(endDate==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Select end date of ad'.tr(),bg: Colors.red,fontColor: Colors.white);

      }
      if(fromTime==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Select start time of ad'.tr(),bg: Colors.red,fontColor: Colors.white);

      }
      if(toTime==null){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Select end time of ad'.tr(),bg: Colors.red,fontColor: Colors.white);

      }

      if(secondsController.text.trim().isEmpty){
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Select second of ad'.tr(),bg: Colors.red,fontColor: Colors.white);

      }
      return false;

    }*/
  }

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateAdLocation(LocationModel locationModel) {
    adLocation = locationModel;
    notifyListeners();
  }

  void addAd(num cardId,String cvv,) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addAd(
          adPhoto!,
          startDate!,
          endDate!,
          adLocation!.latitude!,
          adLocation!.longitude!,
          adLocation!.address!,
          showAdWhere == 1 ? 'homepage' : 'second_page',cardId,cvv);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null && response.response!.data['data'] != null) {
            PaymentResponse paymentResponse = PaymentResponse.fromJson(response.response!.data['data']['payment']);
            bool?result =  await NavigatorHandler.pushReplacement(WebViewPayment(paymentResponse: paymentResponse));
            if(result==true){
              getAds('coming');

            }
          }
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('add ad error>>>${e.toString()}');
    }
  }

  void getAds(String type) async{

    try {

      if(cancelToken!=null&&!cancelToken!.isCancelled){
        cancelToken!.cancel();
      }

      cancelToken ??= CancelToken();


      isLoadingAds = true;
      myAdsList.clear();
      notifyListeners();

      ApiResponse response = await repository.getAds(null,cancelToken);
      isLoadingAds = false;
      cancelToken = null;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'][type].forEach((v) => myAdsList.add(AdModel.fromJson(v)));
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {
      cancelToken = null;

      isLoadingAds = false;
      notifyListeners();
      if(e is DioException){
        if(e.response!.statusCode!=500){
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());

        }
      }
      print('ads error>>>${e.toString()}');

    }
  }

  void getAdDetails(num adId) async{
    isLoadingAdDetails = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getAdDetails(adId);
      isLoadingAdDetails = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          adDetails = AdModel.fromJson(response.response!.data['data']);
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {

      isLoadingAdDetails = false;
      notifyListeners();
      if(e is DioException){
        if(e.response!.statusCode!=500){
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());

        }
      }
      print('ad details error>>>${e.toString()}');

    }
  }

  void calculateAdPrice() async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Wait...'.tr());
    await dialog.show();

    try {
      ApiResponse response = await repository.calculateAdPrice(startDate!,endDate!,showAdWhere == 1 ? 'homepage' : 'second_page');
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          num price = response.response?.data['data']['price'];
          showPaymentCardsSheet(price,null);
        }
      }
    } catch (e) {

      await dialog.hide();
      if(e is DioException){

      }
      print('calculate ad price error>>>${e.toString()}');

    }
  }
}
