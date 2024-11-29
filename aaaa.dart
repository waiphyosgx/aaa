import 'package:falcon_logger/falcon_logger.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../sgx_online_common_services.dart';
import '../../../sgx_online_common_utils.dart';
import '../session_utils/migrate_mobile_storage.dart';

class NativeChannelListener {
  static const MethodChannel _tokenChannel = MethodChannel('$kAppBundleId/token');
  static const MethodChannel _storageChannel = MethodChannel('$kAppBundleId/native_storage');

  static const MethodChannel _notificationChannel = MethodChannel('$kAppBundleId/notifications');

  static Future<void> migrateSession() async {
    GoRouter.optionURLReflectsImperativeAPIs = true;

    //only for android and ios
    try {
      _tokenChannel.setMethodCallHandler(_handleTokenMethod);
      _storageChannel.setMethodCallHandler(_handleStorageMethod);
      await migrateMobileStorage();
      ScreenAwakeUtils.initScreenAwake();
    } catch (e) {
      //
    }
  }

  static Future<void> _handleTokenMethod(MethodCall call) async {
    print('called save token');
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
  static iosNotificationHandler({
    required void Function(dynamic) onReceived,
    required void Function(dynamic) onTapped,
  }) {
    _notificationChannel.setMethodCallHandler((call) async {
      final dynamic payload = call.arguments;

      if (payload != null) {

        if (call.method == "onNotificationReceived") {
          onReceived(payload);
        } else if (call.method == "onNotificationTapped") {
          onTapped(payload);
        }
      }
    });
  }
}
