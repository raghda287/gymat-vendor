import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dateFormat/dateFormat.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/data/models/main_category_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/utils/preferences.dart';
import '../../../data/models/certificate_file_model.dart';
import '../../../data/models/local_day_model.dart';
import '../../../data/models/local_work_time.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../socketProvider.dart';
import '../otp_screen/otp_screen.dart';
import 'package:geocoding/geocoding.dart';

import '../phone_screen/phone_screen.dart';
import '../splash_screen/splash_screen.dart';
import '../user_type_screen/user_type_screen.dart';

enum USERTYPE {
  gym,
  healthClubAndSpa,
  coache,
  healthyFood,
  market,
  sportFieldRentals
}

class AuthProvider with ChangeNotifier {
  AuthRepository authRepository = getIt();
  CountryCode? countryCode;
  String? phone;
  List<MainCategoryModel> userType = [];

  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();

  TextEditingController providerNameController = TextEditingController();
  TextEditingController providerEmailController = TextEditingController();
  TextEditingController siteController = TextEditingController();

  // sign in --- edit provider
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController gymPricePerDayController = TextEditingController();

  // register2
  TextEditingController idNumberController = TextEditingController();

  // register bank details
  TextEditingController ibanNumberController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();

  // coach info register
  TextEditingController aboutCoachController = TextEditingController();

  int seconds = 60;
  Timer? timer;
  bool? isTimerStoped;
  String? gender;
  String? workWithGender;

  String? logoPath;
  String? photoPath;
  String? idPhotoPath;
  String? passportPhotoPath;
  String? commercialRegistrationPhotoPath;
  List<CertificateFileModel> certificatesFile = [];

  List<String> genders = ['male', 'female'];
  bool isLoadingLocation = false;
  LocationModel? locationModel;

  bool isLoadingCategory = false;
  bool isLoadingShopCategory = false;
  bool? isDelevieryService;

  List<MainCategoryModel> categories = [];
  List<String> selectedShopCategoryList = [];
  List<DepartmentModel> shopCategoryList = [];

  ///working times
  List<LocalDayModel> localDays = [
    LocalDayModel('sat'.tr(), 'SAT'),
    LocalDayModel('sun'.tr(), 'SUN'),
    LocalDayModel('mon'.tr(), 'MON'),
    LocalDayModel('tue'.tr(), 'TUE'),
    LocalDayModel('wed'.tr(), 'WED'),
    LocalDayModel('thu'.tr(), 'THU'),
    LocalDayModel('fri'.tr(), 'FRI'),
  ];
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  LocalDayModel? selectedDay;
  List<LocalWorkTime> workTimeList = [];

  bool shopCategoryForEdit = false;

  GoogleSignInAccount? account;
  UserCredential? appleCredential;

  List<String> coachBioCertificates = [];


  void init() {
    countryCode = CountryCode.fromCountryCode('SA');
    isTimerStoped = null;
    timer = null;
    gender = null;
    userType = [];
    isLoadingCategory = false;
    phoneController.clear();
    smsController.clear();
    nameController.clear();
    descriptionController.clear();
    providerNameController.clear();
    providerEmailController.clear();
    siteController.clear();

  }

  void initOtp(String phone) {
    userType = [];
    this.phone = phone;
    isTimerStoped = null;
    stopTimer();
    smsController.clear();
    notifyListeners();
  }

  void initGender() {
    gender = null;
  }

  void initUserType() {
    userType = [];
    categories = [];
    isLoadingCategory = false;
  }

  void initProviderDataRegistration() {
    if (account != null) {
      providerNameController.text = account!.displayName ?? '';
      providerEmailController.text = account!.email ?? '';
    } else if (appleCredential != null && appleCredential!.user != null) {
      providerNameController.text = appleCredential!.user!.displayName ?? '';
      providerEmailController.text = appleCredential!.user!.email ?? '';
    } else {
      providerNameController.clear();
      providerEmailController.clear();
    }
  }

  void initWorkWith() {
    UserModel? userModel = Preferences().getUserData();
    if (userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null) {
      workWithGender = userModel.providerModel!.mainAccount!.for_gender;
    } else {
      workWithGender = null;
    }
  }

  void initEditProfile() {
    logoPath = null;
    photoPath = null;
    gender = null;
    nameController.clear();
    phoneController.clear();
  }

  void initSignUp() {
    UserModel? userModel = Preferences().getUserData();
    if (userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null) {
      countryCode = CountryCode.fromDialCode(
          userModel.providerModel!.phone_code ?? '+966');

      logoPath = userModel.providerModel!.mainAccount!.business_name != null
          ? userModel.providerModel!.mainAccount!.logo
          : null;
      photoPath = userModel.providerModel!.mainAccount!.business_name != null
          ? userModel.providerModel!.mainAccount!.background
          : null;

      nameController.text =
          userModel.providerModel!.mainAccount!.business_name ?? '';
      descriptionController.text =
          userModel.providerModel!.mainAccount!.desc ?? '';
      phoneController.text = userModel.providerModel!.mainAccount!.phone ?? '';
      providerEmailController.text =
          userModel.providerModel!.mainAccount!.email ?? '';
      siteController.text = userModel.providerModel!.mainAccount!.website ?? '';

      gymPricePerDayController.text =
          userModel.providerModel!.mainAccount!.price_day != null
              ? userModel.providerModel!.mainAccount!.price_day.toString()
              : "";

      if (userModel.providerModel!.mainAccount!.latitude != null &&
          userModel.providerModel!.mainAccount!.longitude != null &&
          userModel.providerModel!.mainAccount!.address != null) {
        locationModel = LocationModel(
            userModel.providerModel!.mainAccount!.latitude!.toDouble(),
            userModel.providerModel!.mainAccount!.longitude!.toDouble(),
            userModel.providerModel!.mainAccount!.address!);
      }

      workTimeList.clear();
      List<WorkTime> times = userModel.providerModel!.mainAccount!.work_times;
      for (WorkTime workTime in times) {
        workTimeList.add(LocalWorkTime(
            weekDaysToNum[workTime.day!.toUpperCase()]!,
            workTime.day!.toLowerCase().tr(),
            workTime.day!,
            workTime.from_time!,
            workTime.to_time!));
      }
      workTimeList.sort((x, y) => x.daySort.compareTo(y.daySort));

      if (getUserType() == USERTYPE.market.name) {
        selectedShopCategoryList = [];

        for (ShopCategory model
            in userModel.providerModel!.mainAccount!.shop_categories) {
          selectedShopCategoryList.add(model.id.toString());
        }

        if (selectedShopCategoryList.isNotEmpty) {
          shopCategoryForEdit = true;
        } else {
          shopCategoryForEdit = false;
          getShopCategory();
        }
      }

      if (getUserType() == USERTYPE.healthyFood.name) {
        isDelevieryService =
            userModel.providerModel!.mainAccount!.is_delivery ?? false;
      }

      notifyListeners();

      //canEditAccountInfoPhone = userModel.providerModel!.mainAccount!.phone==null;
    } else {
      locationModel = null;
      shopCategoryList = [];
      isLoadingShopCategory = false;
      selectedShopCategoryList = [];
      logoPath = null;
      photoPath = null;
      locationModel = null;
      isLoadingLocation = false;
      nameController.clear();
      descriptionController.clear();
      siteController.clear();
      workTimeList.clear();
      isDelevieryService = false;
      clearWorkTime();
      shopCategoryForEdit = false;
      if (getUserType() == USERTYPE.market.name) {
        getShopCategory();
      }
      //canEditAccountInfoPhone = false;
    }
  }

  void initSignUpStep2() {
    idNumberController.clear();
    idPhotoPath = null;
    passportPhotoPath = null;
    commercialRegistrationPhotoPath = null;
    certificatesFile = [];
  }

  void initCoachBio(){
    coachBioCertificates = [];
    certificatesFile = [];
  }

  void updateIsDelivery(bool isDelivery) {
    isDelevieryService = isDelivery;
  }

  void socialLogin() async {
    if (Platform.isAndroid) {
      signInWithGoogle();
    } else if (Platform.isIOS) {
      signInWithApple();
    }
  }

  void signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      account = await googleSignIn.signIn();
      if (account != null) {
        googleSignIn.signOut();
        loginWithSocial();
      }
    } catch (e) {
      print('error=>>>${e.toString()}');
    }
  }

  void signInWithApple() async {
    /*  var redirectURL = "https://gymat-79f65.firebaseapp.com/__/auth/handler";
    var clientID = "668945487417-e61horn8cnkr59nq4t615c91rinnl4ku.apps.googleusercontent.com";*/
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    appleCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    loginWithSocial();
  }

  void resetSocialAccount(){
    account = null;
    appleCredential = null;
  }

  void checkPhoneNumber(BuildContext context) {
    String phone = phoneController.text.trim();

    if (countryCode!.dialCode == '+966') {
      if (phone.length == 9 && phone.startsWith('5')) {
        login(context);
      } else if (phone.length == 10 && phone.startsWith('05')) {
        if (phone.startsWith("0")) {
          phone = phone.replaceFirst('0', '');
          login(context);
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title:
                  'Phone number must be 9 digits without 0 or 10 digits start with 0'
                      .tr());
        }
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title:
                'Phone number must be 9 digits without 0 or 10 digits start with 0'
                    .tr());
      }
    } else {
      if (phone.length > 3) {
        login(context);
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Invalid phone number'.tr());
      }
    }
  }

  void startTimer() {
    seconds = 60;
    stopTimer();
    isTimerStoped = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      notifyListeners();
      if (seconds == 0) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      timer = null;
      isTimerStoped = true;
    }
  }

  void checkSmsCode(BuildContext context) {
    String smsCode = smsController.text.trim();
    if (smsCode.length == 4) {
      if (account == null && appleCredential == null) {
        login(context);
      } else {
        NavigatorHandler.pushReplacement(const UserTypeScreen());
      }
    } else {
      CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Invalid sms code'.tr());
    }
  }

  void addRemoveUserType(MainCategoryModel model) {
    if (!userType.contains(model)) {
      userType.add(model);
      notifyListeners();
    } else {
      userType.remove(model);
      notifyListeners();
    }
  }

  void updateGender(String gender) {
    this.gender = gender;
    notifyListeners();
  }

  void updateWorkWithGender(String gender) {
    workWithGender = gender;
    notifyListeners();
  }

  void updateShopCategories(List<String> selectedShopCategory) {
    selectedShopCategoryList = selectedShopCategory;
  }

  void pickImage(ImageSource source, String type, CropAspectRatioPreset? cropAspectRatioPreset) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: source, maxWidth: 512, maxHeight: 1024, imageQuality: 50);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: type =='logo'?const CropAspectRatio(ratioX: 1, ratioY: 1):type == 'photo'?const CropAspectRatio(ratioX: 16, ratioY: 9):null,

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            initAspectRatio: type =='logo'?CropAspectRatioPreset.square:type== 'photo'?CropAspectRatioPreset.ratio16x9:null,
            lockAspectRatio: type =='logo'||type== 'photo',
            cropStyle: type =='logo'?CropStyle.circle:CropStyle.rectangle,

            aspectRatioPresets:type =='logo' ?[CropAspectRatioPreset.square]:type=='photo'? [CropAspectRatioPreset.ratio16x9]:
            [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: type =='logo'||type== 'photo',
            cropStyle: type =='logo'?CropStyle.circle:CropStyle.rectangle,

            aspectRatioPresets:type =='logo' ?[CropAspectRatioPreset.square]:type=='photo'? [CropAspectRatioPreset.ratio16x9]:
            [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        if (type == 'logo') {
          logoPath = 'fileimage:${croppedFile.path}';
        } else if (type == 'photo') {
          photoPath = 'fileimage:${croppedFile.path}';
        } else if (type == 'id') {
          idPhotoPath = croppedFile.path;
        } else if (type == 'passport') {
          passportPhotoPath = croppedFile.path;
        } else if (type == 'commercialRegistration') {
          commercialRegistrationPhotoPath = croppedFile.path;
        } else if (type == 'certificate') {
          if (certificatesFile.length < 5) {
            certificatesFile.add(CertificateFileModel(croppedFile.path, 'png',null));
          }
        }
        notifyListeners();
      }
    }
  }

  void pickUpFile(String type) async {
    var filePickerResult = await FilePicker.platform.pickFiles(
        allowCompression: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (filePickerResult != null) {
      if (type == 'id') {
        idPhotoPath = filePickerResult.files.single.path;
      } else if (type == 'passport') {
        passportPhotoPath = filePickerResult.files.single.path;
      } else if (type == 'commercialRegistration') {
        commercialRegistrationPhotoPath = filePickerResult.files.single.path;
      } else if (type == 'certificate') {
        if (certificatesFile.length < 5) {
          certificatesFile.add(
              CertificateFileModel(filePickerResult.files.single.path!, 'pdf',null));
        }
      }

      notifyListeners();
    }
  }

  void getLocation(String languageId) async {
    if (isLoadingLocation) {
      return;
    }
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      bool result = await Geolocator.openLocationSettings();
      if (result) {
        getLocationData(languageId);
      }
    } else {
      getLocationData(languageId);
    }
  }

  void getLocationData(String languageId) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title:
                'Location permissions are permanently denied, we cannot request permissions.');

        return;
      }

      isLoadingLocation = true;
      notifyListeners();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          );
      String? street;
      String? locality;

      if (placemarks.length > 1) {
        street = placemarks[1].thoroughfare ??
            placemarks[1].street ??
            placemarks[1].name;
        locality = placemarks[0].locality ?? '';
      } else if (placemarks.length == 1) {
        street = placemarks[0].thoroughfare ??
            placemarks[0].street ??
            placemarks[1].name;
        locality = placemarks[0].locality ?? '';
      }
      locationModel = LocationModel(
          position.latitude, position.longitude, '$street-$locality');
      isLoadingLocation = false;

      notifyListeners();
    } catch (e) {
      isLoadingLocation = false;
      notifyListeners();
    }
  }

  void updateCurrentLocation(LocationModel model) {
    locationModel = model;
    notifyListeners();
  }

  void updateSelectedDay(LocalDayModel? selectedDay) {
    this.selectedDay = selectedDay;
    notifyListeners();
  }

  void updateFromTime(TimeOfDay? timeOfDay) {
    fromTime = timeOfDay;
    notifyListeners();
    updateToTime(null);
  }

  void updateToTime(TimeOfDay? timeOfDay) {
    toTime = timeOfDay;
    notifyListeners();
  }

  void clearWorkTime() {
    selectedDay = null;
    fromTime = null;
    toTime = null;
  }

  void addWorkTime() {
    if (fromTime != null && toTime != null && selectedDay != null) {
      LocalWorkTime localWorkTime = LocalWorkTime(
          weekDaysToNum[selectedDay!.value]!,
          selectedDay!.title,
          selectedDay!.value,
          CustomDateTimeFormat().convertTimeOfDayToAmPm(fromTime!),
          CustomDateTimeFormat().convertTimeOfDayToAmPm(toTime!));
      if (!workTimeList.contains(localWorkTime)) {
        workTimeList.add(localWorkTime);
        workTimeList.sort((x, y) => x.daySort.compareTo(y.daySort));
        clearWorkTime();
        NavigatorHandler.pop();
        notifyListeners();
      } else {
        CustomScaffoldMessanger.showToast(
            title: 'This date is added before'.tr(), bg: Colors.red);
      }
    } else {
      CustomScaffoldMessanger.showToast(
          title: 'Check data'.tr(), bg: Colors.red);
    }
  }

  void deleteWorkTime(int index) {
    workTimeList.removeAt(index);
    notifyListeners();
  }

  void addCertificate(String cert) {
    if(!coachBioCertificates.contains(cert)){
      coachBioCertificates.add(cert);
      notifyListeners();
    }
  }

  void removeCertificate(int index) {
    coachBioCertificates.removeAt(index);
    notifyListeners();
  }


  bool canShowWorkTime() {
    UserModel? userModel = Preferences().getUserData();
    if (userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null &&
        (userModel.providerModel!.mainAccount!.category.type ==
                USERTYPE.coache.name ||
            userModel.providerModel!.mainAccount!.category.type ==
                USERTYPE.market.name)) {
      return false;
    }
    return true;
  }

  void deleteCertificatesFiles(index) {

    if(certificatesFile[index].filePath.startsWith('http')){
      deleteCertificate(index);
    }else{
      certificatesFile.removeAt(index);
      notifyListeners();
    }


  }

  void checkCertificatesFiles() {
    String id = idNumberController.text.trim();
    if (id.length == 10 &&
        idPhotoPath != null &&
        passportPhotoPath != null &&
        commercialRegistrationPhotoPath != null) {
      updateCertificatesFileInfo();
    } else if (id.length < 10) {
      CustomScaffoldMessanger.showToast(title: 'Id number is invalid'.tr());
    } else if (idPhotoPath == null) {
      CustomScaffoldMessanger.showToast(title: 'Id photo is required'.tr());
    } else if (passportPhotoPath == null) {
      CustomScaffoldMessanger.showToast(
          title: 'Passport photo is required'.tr());
    } else if (commercialRegistrationPhotoPath == null) {
      CustomScaffoldMessanger.showToast(
          title: 'Commercial photo is required'.tr());
    }
  }

  void checkAccountInfoData() {
    RegExp regExpPrice = RegExp(r'^\d*\.?\d{1,2}$');
    RegExp urlRegExp = RegExp(
        r"^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9\-.]+(?:\.[a-zA-Z]{2,})+(?:\/\S*)?$");
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    String phone = phoneController.text.trim();

    String email = providerEmailController.text.trim();
    String site = siteController.text.trim();
    String pricePerDay = gymPricePerDayController.text.trim();

    if (logoPath != null &&
        photoPath != null &&
        locationModel != null &&
        name.isNotEmpty &&
        ((phone.length == 9 && phone.startsWith('5')) ||
            (phone.length == 10 && phone.startsWith('05'))) &&
        description.isNotEmpty) {
      if (email.isNotEmpty && !EmailValidator.validate(email)) {
        CustomScaffoldMessanger.showToast(title: 'Invalid email address'.tr());

        return;
      } else if (site.isNotEmpty && !urlRegExp.hasMatch(site)) {
        CustomScaffoldMessanger.showToast(title: 'Invalid website'.tr());
        return;
      }

      if (getUserType() != null && getUserType() == USERTYPE.gym.name) {
        if (regExpPrice.hasMatch(pricePerDay)) {
          if (canShowWorkTime()) {
            if (workTimeList.isNotEmpty) {
              updateAccountInfo();
            } else {
              CustomScaffoldMessanger.showToast(
                  title: 'Working times are required'.tr());
            }
          } else {
            updateAccountInfo();
          }
        } else {
          CustomScaffoldMessanger.showToast(
              title: 'Subscription price per day required'.tr());
        }
      } else if (getUserType() != null &&
          getUserType() == USERTYPE.market.name) {
        if (selectedShopCategoryList.isNotEmpty) {
          if (canShowWorkTime()) {
            if (workTimeList.isNotEmpty) {
              updateAccountInfo();
            } else {
              CustomScaffoldMessanger.showToast(
                  title: 'Working times are required'.tr());
            }
          } else {
            updateAccountInfo();
          }
        } else {
          CustomScaffoldMessanger.showToast(
              title: 'You have to choose only 1 category at least'.tr());
        }
      } else {
        if (canShowWorkTime()) {
          if (workTimeList.isNotEmpty) {
            updateAccountInfo();
          } else {
            CustomScaffoldMessanger.showToast(
                title: 'Working times are required'.tr());
          }
        } else {
          updateAccountInfo();
        }
      }
    } else if (logoPath == null) {
      CustomScaffoldMessanger.showToast(title: 'Logo is required'.tr());
    } else if (photoPath == null) {
      CustomScaffoldMessanger.showToast(title: 'Photo is required'.tr());
    } else if (locationModel == null) {
      CustomScaffoldMessanger.showToast(title: 'Location is required'.tr());
    } else if (name.isEmpty) {
      CustomScaffoldMessanger.showToast(title: 'Name is required'.tr());
    } else if (getUserType() != null &&
        getUserType() == USERTYPE.gym.name &&
        !regExpPrice.hasMatch(pricePerDay)) {
      CustomScaffoldMessanger.showToast(
          title: 'Subscription price per day required'.tr());
    } else if (phone.length < 9 ||
        (phone.length == 9 && !phone.startsWith('5')) ||
        (phone.length == 10 && !phone.startsWith('05'))) {
      CustomScaffoldMessanger.showToast(
          title:
              'Phone number must be 9 digits without 0 or 10 digits start with 0'
                  .tr());
    } else if (description.isEmpty) {
      CustomScaffoldMessanger.showToast(title: 'Description is required'.tr());
    }
  }

  String? getUserType() {
    UserModel? userModel = Preferences().getUserData();
    if (userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null &&
        userModel.providerModel!.mainAccount!.category.type != null) {
      return userModel.providerModel!.mainAccount!.category.type;
    }
    return null;
  }

  void updateCountryCode(CountryCode countryCode) {
    this.countryCode = countryCode;
    notifyListeners();
  }

  //calling apis

  void getMainCategories() async {
    categories.clear();
    isLoadingCategory = true;
    notifyListeners();
    try {
      ApiResponse response = await authRepository.getMainCategories();
      isLoadingCategory = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data']
              .forEach((v) => categories.add(MainCategoryModel.fromJson(v)));
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      isLoadingCategory = false;
      notifyListeners();
      print('category error>>>${e.toString()}');
    }
  }

  void login(BuildContext context) async {
    stopTimer();

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Logining...'.tr());

    try {
      await dialog.show();
      ApiResponse response = await authRepository.login(
          countryCode!.dialCode!, phoneController.text.trim());
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          account = null;
          appleCredential = null;
          SocketProvider socketProvider = getIt();
          socketProvider.connectToSocket();
          phone = phoneController.text.trim();
          if(response.response!.data['message']=="The code has been sent successfully."|| response.response!.data['message']=="تم ارسال الكود بنجاح"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(phone: phone!)));
            phoneController.clear();
          }
          else{
            CustomScaffoldMessanger.showScaffoledMessanger(
                title: response.response!.data['message']);
            phoneController.clear();
          }
        } else if (response.code == 422) {
          NavigatorHandler.pushReplacement(const UserTypeScreen());
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
          phoneController.clear();
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('signUp error>>>${e.toString()}');
    }
  }

  void confirmCode()async{
    stopTimer();
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Logining...'.tr());
    try{
      ApiResponse apiResponse = await authRepository.confirmCode(countryCode!.dialCode!, phone!, smsController.text);
      await dialog.hide();
      if(apiResponse.response!.statusCode==200 || apiResponse.response!.statusCode==201){
        if(apiResponse.code==200){
          Preferences preferences = Preferences();
          UserModel userModel =
          UserModel.fromJson(apiResponse.response!.data['data']);
          preferences.saveUserData(userModel);
          phoneController.clear();
          account = null;
          appleCredential = null;
          SocketProvider socketProvider = getIt();
          socketProvider.connectToSocket();

          Widget? screen = NavigatorHandler().getHomeScreen();
          if (screen != null) {
            NavigatorHandler.pushAndRemoveUntil(screen);

          }
        } else if (apiResponse.code == 422) {
          NavigatorHandler.pushReplacement(const UserTypeScreen());
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: apiResponse.innerMessage ?? '');
        }
      }
    }catch(e){
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  void signUp() async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Signing Up...'.tr());
    String name =  providerNameController.text.trim();
    String code = countryCode!.dialCode!;
    String phone = phoneController.text.trim();
    try {
      await dialog.show();

      String? socialId;
      String? socialType;

      if (account != null) {
        socialId = account!.id;
        socialType = 'google';
      } else if (appleCredential != null && appleCredential!.user != null) {
        socialId = appleCredential!.user!.uid;
        socialType = 'apple';
      }

      List<String> categoryIds = [];
      for (MainCategoryModel model in userType) {
        categoryIds.add(model.id.toString());
      }

      ApiResponse response = await authRepository.signUp(
         name,
          providerEmailController.text.trim(),
          code,
          phone,
          gender!,
          categoryIds,
          socialType,
          socialId);

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          // Preferences preferences = Preferences();
          // UserModel userModel = UserModel.fromJson(response.response!.data['data']);
          //
          // preferences.saveUserData(userModel);
          // userType.clear();
          // gender = null;
          // phoneController.clear();
          // providerNameController.clear();
          // providerEmailController.clear();
          // account = null;
          // appleCredential = null;
          // SocketProvider socketProvider = getIt();
          // socketProvider.connectToSocket();
          //
          // Widget? screen = NavigatorHandler().getHomeScreen();
          // if (screen != null) {
          //   NavigatorHandler.pushAndRemoveUntil(screen);
          // }

          await dialog.hide();
          NavigatorHandler.push(OtpScreen(phone: phone!));
        } else {
          await dialog.hide();
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
        }
      } else {
        await dialog.hide();
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: response.innerMessage ?? 'Something went wrong'.tr());
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('signUp error>>>${e.toString()}');
    }
  }

  void updateCertificatesFileInfo() async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();

      ApiResponse response =
          await authRepository.updateProviderCertificatesFiles(
              idNumberController.text.trim(),
              idPhotoPath!,
              passportPhotoPath!,
              commercialRegistrationPhotoPath!,
              certificatesFile);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          certificatesFile.clear();
          idNumberController.clear();
          idPhotoPath = null;
          passportPhotoPath = null;
          commercialRegistrationPhotoPath = null;

          Preferences preferences = Preferences();
          UserModel? userModel = preferences.getUserData();
          if (userModel != null) {
            userModel.providerModel!.sign_info = true;
            preferences.saveUserData(userModel);
            ProfileProvider profileProvider = getIt();
            profileProvider.updateUserData(userModel);
            NavigatorHandler.pop();
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('update certificates  error>>>${e.toString()}');
    }
  }

  void updateAccountInfo() async {
    UserModel? userModel = Preferences().getUserData();
    if (userModel == null ||
        userModel.providerModel == null ||
        userModel.providerModel!.mainAccount == null) {
      return;
    }

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      String? email = providerEmailController.text.trim();
      String? site = siteController.text.trim();
      String? gymPricePerday = gymPricePerDayController.text.trim();

      String phoneNumber = phoneController.text.trim().startsWith('0')
          ? phoneController.text.trim().replaceFirst('0', '')
          : phoneController.text.trim();

      ApiResponse response = await authRepository.updateAccountInfo(
          userModel.providerModel!.mainAccount!.id.toString(),
          logoPath!,
          photoPath!,
          locationModel!,
          nameController.text.trim(),
          countryCode!.dialCode!,
          phoneNumber,
          descriptionController.text.trim(),
          workTimeList,
          email,
          site,
          gymPricePerday.isEmpty ? null : gymPricePerday,
          selectedShopCategoryList,
          isDelevieryService);

      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          clearWorkTime();
          nameController.clear();
          phoneController.clear();
          descriptionController.clear();
          providerEmailController.clear();
          siteController.clear();
          locationModel = null;
          logoPath = null;
          photoPath = null;
          selectedShopCategoryList = [];

          AccountsModel accountsModel =
              AccountsModel.fromJson(response.response!.data['data']);
          Preferences preferences = Preferences();
          UserModel? userModel = preferences.getUserData();
          if (userModel != null) {
            userModel.providerModel!.mainAccount = accountsModel;
            int index = 0;
            for (AccountsModel model in userModel.providerModel!.accounts) {
              if (model.id == accountsModel.id) {
                userModel.providerModel!.accounts[index] = accountsModel;
                break;
              }
              index++;
            }
            preferences.saveUserData(userModel);
            ProfileProvider profileProvider = getIt();
            profileProvider.updateUserData(userModel);
            NavigatorHandler.pop();
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('update account info error>>>${e.toString()}');
    }
  }

  void updateAccountWorkWith() async {
    UserModel? userModel = Preferences().getUserData();
    if (userModel == null ||
        userModel.providerModel == null ||
        userModel.providerModel!.mainAccount == null) {
      return;
    }

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      ApiResponse response = await authRepository.updateAccountWorkWith(
          userModel.providerModel!.mainAccount!.id.toString(), workWithGender!);

      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          AccountsModel accountsModel =
              AccountsModel.fromJson(response.response!.data['data']);
          Preferences preferences = Preferences();
          UserModel? userModel = preferences.getUserData();
          if (userModel != null) {
            userModel.providerModel!.mainAccount = accountsModel;
            int index = 0;
            for (AccountsModel model in userModel.providerModel!.accounts) {
              if (model.id == accountsModel.id) {
                userModel.providerModel!.accounts[index] = accountsModel;
                break;
              }
              index++;
            }
            preferences.saveUserData(userModel);
            ProfileProvider profileProvider = getIt();
            profileProvider.updateUserData(userModel);
            workWithGender = null;
            NavigatorHandler.pop();
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('update account info error>>>${e.toString()}');
    }
  }

  void updateCoachBioData(String bio, String education, String experience) async{
    UserModel? userModel = Preferences().getUserData();
    if (userModel == null ||
        userModel.providerModel == null ||
        userModel.providerModel!.mainAccount == null) {
      return;
    }

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      String cert = coachBioCertificates.join(',');
      ApiResponse response = await authRepository.updateCoachBioData(userModel.providerModel!.mainAccount!.id!, bio,education,experience,cert,certificatesFile);


      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          AccountsModel accountsModel = AccountsModel.fromJson(response.response!.data['data']);
          Preferences preferences = Preferences();
          UserModel? userModel = preferences.getUserData();
          if (userModel != null) {
            userModel.providerModel!.mainAccount = accountsModel;
            int index = 0;
            for (AccountsModel model in userModel.providerModel!.accounts) {
              if (model.id == accountsModel.id) {
                userModel.providerModel!.accounts[index] = accountsModel;
                break;
              }
              index++;
            }
            preferences.saveUserData(userModel);
            ProfileProvider profileProvider = getIt();
            profileProvider.updateUserData(userModel);
            NavigatorHandler.pop();
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: response.innerMessage ?? '');
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('update coach bio account info error>>>${e.toString()}');
    }
  }

  void getShopCategory() async {
    shopCategoryList.clear();
    isLoadingShopCategory = true;
    notifyListeners();
    try {
      ApiResponse response = await authRepository.getShopCategories();
      isLoadingShopCategory = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach(
              (v) => shopCategoryList.add(DepartmentModel.fromJson(v)));
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      isLoadingShopCategory = false;
      notifyListeners();
      print('category error>>>${e.toString()}');
    }
  }

  void loginWithSocial() async {
    String? socialId;
    String? socialType;

    if (account != null) {
      socialId = account!.id;
      socialType = 'google';
    } else if (appleCredential != null && appleCredential!.user != null) {
      socialId = appleCredential!.user!.uid;
      socialType = 'apple';
    }

    if (socialType == null || socialId == null) {
      CustomScaffoldMessanger.showToast(title: 'Invalid auth');
      return;
    }

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Logining...'.tr());

    try {
      await dialog.show();

      ApiResponse response =
          await authRepository.socialLogin(socialType, socialId);

      if (response.response != null &&
          (response.response!.statusCode == 200 ||
              response.response!.statusCode == 201)) {
        await dialog.hide();

        if (response.code == 200) {
          Preferences preferences = Preferences();
          UserModel userModel =
              UserModel.fromJson(response.response!.data['data']);
          preferences.saveUserData(userModel);
          Widget? screen = NavigatorHandler().getHomeScreen();
          if (screen != null) {
            NavigatorHandler.pushAndRemoveUntil(screen);
          }
        } else if (response.code == 422) {
          NavigatorHandler.push(const PhoneScreen());
        }
      }
    } catch (e) {
      await dialog.hide();
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
      print('login social error>>>${e.toString()}');
    }
  }

  void logout() async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Logging out...'.tr());
    try {
      await dialog.show();
      ApiResponse response = await authRepository.logout();
      await dialog.hide();

      if (response.response != null && (response.response!.statusCode == 200 || response.response!.statusCode == 201)) {

        if (response.code==200) {
          onLogoutSuccess();


        }
      }
    } catch (e) {
      dialog.hide();
      print('logout error>>>${e.toString()}');
    }
  }

  void deleteAccount() async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Deleting account...'.tr());
    try {
      dialog.show();
      ApiResponse response = await authRepository.deleteAccount();

      if (response.response != null && (response.response!.statusCode == 200 || response.response!.statusCode == 201)) {
        if (response.code ==200) {
          onLogoutSuccess();
        }
      }
    } catch (e) {
      dialog.hide();
      print('delete account error>>>${e.toString()}');
    }
  }

  void onLogoutSuccess() {
    Preferences preferences = Preferences();
    preferences.logout();
    NavigatorHandler.pushAndRemoveUntil(const SplashScreen());

    SocketProvider socketProvider = getIt();

    socketProvider.disconnectToSocket();




  }

  void deleteCertificate(int index) async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Deleting ...'.tr());

    dialog.show();
    ApiResponse response = await authRepository.deleteCertificate(certificatesFile[index].id);
    dialog.hide();

    if (response.response != null && (response.response!.statusCode == 200 || response.response!.statusCode == 201)) {
      if (response.code ==200) {
        certificatesFile.removeAt(index);
        Preferences preferences = Preferences();
        UserModel? userModel = preferences.getUserData();
        if (userModel != null&&userModel.providerModel!=null&&userModel.providerModel!.mainAccount!=null&&userModel.providerModel!.mainAccount!.user_data!=null) {

          List<IdentificationData> certificatesList = userModel.providerModel!.mainAccount!.user_data!.certificates;
          userModel.providerModel!.mainAccount!.user_data!.certificates.clear();
          userModel.providerModel!.mainAccount!.user_data!.certificates.addAll(certificatesList);
          preferences.saveUserData(userModel);

        }
        notifyListeners();

      }
    }

    try {

    } catch (e) {
      dialog.hide();
      print('delete certificate error>>>${e.toString()}');
    }
  }


}
