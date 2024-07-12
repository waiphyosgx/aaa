import 'package:freezed_annotation/freezed_annotation.dart';
part 'favourite_api_parameter_model.g.dart';
part 'favourite_api_parameter_model.freezed.dart';

@freezed
class FavouriteApiParameterModel with _$FavouriteApiParameterModel {
  FavouriteApiParameterModel._();
  factory FavouriteApiParameterModel({
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'device_token') String? deviceToken,
    @JsonKey(name: 'device_type') String? deviceType,
    @JsonKey(name: 'watchlist_folders') String? watchListFolders,
    @JsonKey(name: 'lower_limit') String? lowerLimit,
    @JsonKey(name: 'upper_limit') String? upperLimit,
    @JsonKey(name: 'notify') String? notify,
    @JsonKey(name: 'stock_code') String? stockcode,
    @JsonKey(name: 'c_notify') String? cNotify,
    @JsonKey(name: 'cmd') String? cmd,
    @JsonKey(name: 'folder_name') String? foldername,
    @JsonKey(name: 'folder_name_new') String? foldernameNew,
    @JsonKey(name: 'favouritesJson') List<Map<String, dynamic>>? favouritesJson,
    @JsonKey(name : 'social_login_id') String? socialLoginId,
    @JsonKey(name: 'push_token') String? pushToken,
  }) = _FavouriteApiParameterModel;
  factory FavouriteApiParameterModel.fromJson(Map<String, dynamic> json) => _$FavouriteApiParameterModelFromJson(json);

  Map<String, dynamic> get getParams {
    Map<String, dynamic> params = {};
    if (userId != null) params['user_id'] = userId;
    if (deviceToken != null) params['device_token'] = deviceToken;
    if (deviceType != null) params['device_type'] = deviceType;
    if (watchListFolders != null) params['watchlist_folders'] = watchListFolders;
    if (lowerLimit != null) params['lower_limit'] = lowerLimit;
    if (upperLimit != null) params['upper_limit'] = upperLimit;
    if (notify != null) params['notify'] = notify;
    if (stockcode != null) params['stock_code'] = stockcode;
    if (cNotify != null) params['c_notify'] = cNotify;
    if (cmd != null) params['cmd'] = cmd;
    if (foldername != null) params['folder_name'] = foldername;
    if (foldernameNew != null) params['folder_name_new'] = foldernameNew;
    if (favouritesJson != null) params['favouritesJson'] = favouritesJson;
    if(socialLoginId != null) params['social_login_id'] = socialLoginId;
    if(pushToken != null) params['push_token'] = pushToken;
    return params;
  }
}
