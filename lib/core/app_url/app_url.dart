class AppUrls {
  static const String baseUrl = 'https://gymatapp.com/';
  static const String baseUrlApi = 'https://gymatapp.com/api/';

  static const String socketUrl = 'https://node.gymatapp.com/';

  ///////////////////////socketUrls/////////////////////////////
  static const String socketJoinRooms = 'gimat_join_rooms';
  static const String socketJoinMarket = 'gimat_market_join';


  static const String socketSendFirstMessage = 'gimat_one_user_send_data';
  static const String socketSendMessage = 'gimat_one_room_send_data';



  static const String socketReceiveFirstMessage = 'gimat_one_market_receive_data';
  static const String socketReceiveMessage = 'gimat_one_room_receive_data';
  static const String socketLeaveRooms = 'gimat_leaves_rooms';


  ///////////////////////socketUrls/////////////////////////////

//endPoints

  static const String marketHomeData = 'provider/market/home';
  static const String marketFollowers = 'provider/market/followers';
  static const String marketFollowerDelete = 'provider/market/deleteFollow';

  static const String mainCategory = 'categories';
  static const String signUp = 'provider/auth/register';
  static const String login = 'provider/auth/login';

  static const String socialLogin = "provider/auth/checkProviderSocial";
  static const String updateFirebaseToken = 'provider/profile/updateToken';
  static const String logout = 'provider/profile/logout';
  static const String deleteAccount = 'provider/profile/deleteAccount';
  static const String deleteCertificate = 'provider/profile/deleteOneCertificate';

  static const String updateSignUpInfo = 'provider/profile/updateSignUpInfo';
  static const String updateAccountInfo = 'provider/market/updateMarketData';
  static const String updateAccountWorkWith = 'provider/market/updateMarketForGender';
  static const String updateCoachAccountBioData = 'provider/profile/updateCoachInfo';

  static const String gymCategories = 'gym/provider/market/categories';
  static const String gymService = 'gym/provider/market/services';
  static const String gymAddMemberShipService = 'gym/provider/market/servicesMembership';
  static const String spaCategories = 'spa/provider/market/categories';
  static const String spaService = 'spa/provider/market/services';
  static const String spaSpecialists = 'spa/provider/market/specialists';
  static const String healthtFoodCategories = 'food/provider/market/categories';
  static const String healthtFoodService = 'food/provider/market/services';
  static const String sportsFieldCategories = 'sport/provider/market/categories';
  static const String sportsFieldService = 'sport/provider/market/services';
  static const String shopCategories = 'shop/provider/market/categories';
  static const String mainShopCategories = 'shopCategories';
  static const String ad = 'provider/market/ad';
  static const String shopService = 'shop/provider/market/products';
  static const String coachCategories = 'coach/provider/market/categories';
  static const String coachService = 'coach/provider/market/services';
  static const String coachWorkouts = 'coach/provider/market/workouts';
  static const String coachWorkoutsUpdateVideo = 'coach/provider/market/updateWorkoutVideo';
  static const String coachLiveSession = 'coach/provider/market/live-session';
  static const String coachOrders = 'coach/provider/market/orders';


  static const String gymOrders = 'gym/provider/market/orders';
  static const String gymOrder = 'gym/provider/market/orders';
  static const String spaOrders = 'spa/provider/market/orders';
  static const String sportsFieldOrders = 'sport/provider/market/orders';
  static const String scanQrCode = 'provider/market/order';
  static const String foodOrders = 'food/provider/market/orders';
  static const String shopOrders = 'shop/provider/market/orders';


  static const String chatRooms = 'provider/market/chat';
  static const String chatCreateGetRoomDataMessages = 'provider/market/chat/create';
  static const String createVideoChatUrl = 'coach/createCall';
  static const String chatPaginationMessages = 'provider/market/paginateMessages';
  static const String userProfile = 'provider/market/getUser';

  static const String charts  = 'provider/market/chart';
  static const String getGoals = 'provider/market/getGoals';
  static const String saveGoals = 'provider/market/updateGoals';
  static const String marketData = 'provider/market/data';
  static const String allRoomsIds = "provider/market/getRoomsIds";
  static const String notification = "provider/market/notifications";
  static const String notificationSetting = "provider/market/getNotificationStatus";
  static const String notificationSettingStatus = "provider/market/updateNotificationStatus";
  static const String chatSettingStatus = "provider/market/updateMessageStatus";
  static const String bookingsSettingStatus = "provider/market/updateBookableStatus";
  static const String wallet = 'provider/market/wallet';
  static const String profile = 'provider/profile';
  static const String paymentCards = 'provider/profile/paymentCards';
  static const String calculateAdPrice = 'provider/market/calculateAdPrice';



}
