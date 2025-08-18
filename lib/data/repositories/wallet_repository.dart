
import 'package:dio/dio.dart';
import '../../core/app_url/app_url.dart';
import '../../core/utils/preferences.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class WalletRepository {
  Future<ApiResponse> getBalance(int page,[CancelToken? cancelToken]) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.wallet,cancelToken: cancelToken,queryParameters: {
        'market_id':markertId,
        'page':page,'limit':50});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
