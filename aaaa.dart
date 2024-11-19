import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';

import 'package:falcon_logger/falcon_logger.dart';

import '../../../sgx_online_common_utils.dart';
import '../native_utils/flutter_channel_invoker.dart';

SessionUtils sessionUtils = SessionUtils();
Future<void> migrateMobileStorage() async {
  String uid = await sessionUtils.getDeviceToken();
  String privateKey = await sessionUtils.getPrivateKey();
  if (!kIsWeb && (uid.isEmpty || privateKey.isEmpty)) {
    try {
      String? privateKey;
      //device id
      String? deviceId;
      //firebase token key
      String? pushToken;
      //user id for favourite social login
      String? userId;
      // String? push_token;

      if (Platform.isAndroid) {
        final oldSharedPrefPath = await _getNativeSharedPreferencesPath();
        File file = File(oldSharedPrefPath);
        if (file.existsSync()) {
          String contents = await file.readAsString();
          final document = XmlDocument.parse(contents);
          Map<String, dynamic> nativePreferencesValue = {};
          Iterable<XmlElement> elements = document.rootElement.children.whereType<XmlElement>();
          for (XmlElement element in elements) {
            String key = element.getAttribute('name') ?? '';
            if(element.children.isNotEmpty && element.children.first.value != null) {
               nativePreferencesValue[key] = element.children.first.value; // Store as string by default
            }
          }
          privateKey = nativePreferencesValue['SYNC_PUB_KEY'];
          deviceId = nativePreferencesValue['DEVICE_ID'];
          // gcmKey = nativePreferencesValue['GCM'];
          pushToken = nativePreferencesValue['TOKEN_PUSH'];
          userId = nativePreferencesValue['UID'];
          if(userId != null || userId?.isEmpty == null){
            userId = deviceId;
          }
          print('private key is ${privateKey?.length} device id is $deviceId push token is $pushToken user id is $userId');
          if (privateKey != null) {
            await sessionUtils.savePrivateKey(privateKey: privateKey);
          }
          if (userId != null) {
            sessionUtils.saveUUID(uuid: userId);
          }
          if (deviceId != null) {
            await sessionUtils.saveDeviceToken(uuid: deviceId);
          }
          if (pushToken != null) {
            await sessionUtils.savePushTokenKey(pushToken);
          }
        }
      }
    } catch (e) {
      Log.e('migrateMobileStorage - error: $e');
    }
  }
}

Future<String> _getNativeSharedPreferencesPath() async {
  if (Platform.isAndroid) {
    Directory directory = Directory('/data/user/0/com.sgx.SGXandroid');
    //android shared preference location
    String sharedPreferenceLocation = '${directory.path}/shared_prefs/SGX_SHARED_PREFERENCES.xml';
    return sharedPreferenceLocation;
  }  else {
    return throw Exception('unsupported platform');
  }
}



import 'dart:io';

import 'package:falcon_logger/falcon_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../sgx_online_common_services.dart';
import '../../../sgx_online_common_utils.dart';
import '../session_utils/migrate_mobile_storage.dart';

class NativeChannelListener {
  static const MethodChannel _tokenChannel = MethodChannel('$kAppBundleId/token');
  static const MethodChannel _storageChannel = MethodChannel('$kAppBundleId/native_storage');

  static Future<void> migrateOldApp() async{
    GoRouter.optionURLReflectsImperativeAPIs = true;

    //only for android and ios
    try {
      if (Platform.isIOS) {
        _tokenChannel.setMethodCallHandler(_handleTokenMethod);
        _storageChannel.setMethodCallHandler(_handleStorageMethod);
      }
      else if (Platform.isAndroid) {
        migrateMobileStorage();
      }
      ScreenAwakeUtils.initScreenAwake();
    }
    catch(e){
      //
    }
  }

  static Future<void> _handleTokenMethod(MethodCall call) async {
    switch (call.method) {
      case 'saveToken':
        _updatePushToken(call.arguments);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'The method ${call.method} is not implemented',
        );
    }
  }

  static Future<String?> _handleStorageMethod(MethodCall call) async {
    try {
      if (call.method == "storage") {
        String key = call.arguments as String;
        switch (key) {
          case "privateKey":
            return await _getSessionUtils().getPrivateKey();
          case "devideId":
            return await _getSessionUtils().getDeviceToken();
          case "userId":
            return await _getSessionUtils().getDeviceToken();
          case "announcement":
            return await _getSessionUtils().getAnnouncementToken();
          default:
            return "";
        }
      }
      return "";
    } catch (e) {
      Log.e('_handleStorageMethod e - $e');
      return "";
    }
  }

 static SessionUtils _getSessionUtils() {
    return SessionUtils();
  }

 static void _updatePushToken(String token) async {
    UserSyncService userSyncService = GetIt.I.get();
    await userSyncService.updatePushToken(token);
  }
}



