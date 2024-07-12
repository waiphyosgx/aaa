import 'dart:convert';

import 'package:falcon_network/falcon_network.dart';
import 'package:get_it/get_it.dart';
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import '../../../sgx_online_favourites_model.dart';
import '../../../sgx_online_favourites_service.dart';

class FavouriteListServiceBauImpl extends FavouriteService {
  FavouriteListServiceBauImpl({
    FalconNetwork? falconNetwork,
  }) {
    this.falconNetwork = falconNetwork ?? GetIt.I.get<FalconNetwork>(instanceName: mobileId);
  }
  late FalconNetwork falconNetwork;
  final SessionUtils _sessionUtils = SessionUtils();
  @override
  Future<List<FollowedFavouriteModel>> userFollowedFavourites({
    required FavouriteApiParameterModel favouriteApiParameterModel,
  }) async {
    try {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      String xAuthToken = await _generateToken(time);
      String uuid = await _sessionUtils.getUUID();
      String deviceToken = await _sessionUtils.getDeviceToken();
      if (uuid.isEmpty) {
        uuid = deviceToken;
      }
      favouriteApiParameterModel = favouriteApiParameterModel.copyWith(
        userId: uuid,
        deviceToken: deviceToken,
      );
      dynamic resp = await falconNetwork.httpPostObj(
        '',
        payload: favouriteApiParameterModel.toJson(),
        headers: {
          authTimeStamp: time,
          authToken: xAuthToken,
        },
        contentType: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      dynamic decodedResp = json.decode(resp ?? '{}');

      final followedFavouriteModel = (decodedResp as List).map((e) => FollowedFavouriteModel.fromJson(e)).toList();
      return followedFavouriteModel;
    } catch (e) {
      return [];
    }
  }

  Future<String> _generateToken(String time) async {
    String deviceToken = await _sessionUtils.getDeviceToken();
    String uuid = await _sessionUtils.getUUID();
    String privateKey = await _sessionUtils.getPrivateKey();
    if (uuid.trim().isEmpty) {
      uuid = deviceToken;
    }
    return generateToken(time, uuid, deviceToken, privateKey);
  }

  @override
  Future<List<WatchListFavouriteModel>> watListFavouriteServices(
      {required FavouriteApiParameterModel favouriteApiParameterModel}) async {
    try {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      String deviceToken = await _sessionUtils.getDeviceToken();
      String uuid = await _sessionUtils.getUUID();
      if (uuid.trim().isEmpty) {
        uuid = deviceToken;
      }
      favouriteApiParameterModel = favouriteApiParameterModel.copyWith(
        userId: uuid,
        deviceToken: deviceToken,
      );
      String xAuthToken = await _generateToken(time);
      final resp = await falconNetwork.httpPostObj(
        '',
        payload: (favouriteApiParameterModel.getParams),
        headers: {
          authToken: xAuthToken,
          authTimeStamp: time,
        },
        contentType: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      dynamic decodedResp = json.decode(resp);

      final addWatchListFolderResponse = (decodedResp as List).map((e) => WatchListFavouriteModel.fromJson(e)).toList();
      return addWatchListFolderResponse;
    } catch (e) {
      throw Exception('');
    }
  }

  @override
  Future<MergedFavouriteModel> mergedFavouriteService(
      {required FavouriteApiParameterModel favouriteApiParameterModel}) async {
    try {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      String deviceToken = await _sessionUtils.getDeviceToken();
      String uuid = await _sessionUtils.getUUID();
      if (uuid.trim().isEmpty) {
        uuid = deviceToken;
      }
      String xAuthToken = await _generateToken(time);
      final resp = await falconNetwork.httpPostObj(
        '',
        payload: favouriteApiParameterModel.getParams,
        headers: {
          authToken: xAuthToken,
          authTimeStamp: time,
        },
        contentType: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      dynamic decodedResp = json.decode(resp);

      return MergedFavouriteModel.fromJson(decodedResp);
    } catch (e) {
      throw Exception('');
    }
  }
}
