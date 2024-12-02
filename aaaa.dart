import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:falcon_logger/falcon_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as google;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huawei_push/huawei_push.dart' as hw;
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:sgx_online_common/src/utils/native_utils/price_list_cahce_utils.dart';
import 'package:sgx_online_common/src/widgets/notifications/notification_popup.dart';

Future<String?> getNotificationToken(GoRouter router) async {
  //for huawei
  if (Platform.isAndroid && await isHmsAvailable()) {
    return Future(() async {
      final Completer<String> completer = Completer<String>();
      bool isGranted = await hw.Push.isAutoInitEnabled();
      if (!isGranted) {
        await hw.Push.setAutoInitEnabled(true);
      }

      hw.Push.getTokenStream.listen((token) {
        if (!completer.isCompleted) {
          completer.complete(token);
        }
      });
      hw.Push.getToken('');

      final complete = await completer.future;

      return complete;
    });
  }
  //for firebase (google android + apple)
  else {
    if (Firebase.apps.isEmpty) {
      //double check for it
      await Firebase.initializeApp();
    }
    google.FirebaseMessaging firebaseMessaging =
        google.FirebaseMessaging.instance;
    //request noti permission
    await firebaseMessaging.requestPermission();
    //get push token
    if (Platform.isIOS) {
      return await firebaseMessaging.getAPNSToken();
    }
    return await firebaseMessaging.getToken();
  }
}

Future<void> registerNotification(GoRouter router) async {
  //notification when app is not active
  if (Platform.isAndroid && await isHmsAvailable()) {
    await hw.Push.setAutoInitEnabled(true);
   hw.Push.onMessageReceivedStream.listen(
      (message) {
        try {
          final data = message.data;
          final decodedData = jsonDecode(data ?? '{}');
          final payloadList = decodedData['hcm'] as List;
          Map<String, dynamic> payload = {};

          for (var p in payloadList) {
            payload.addAll(p);
          }

          if (payload.isNotEmpty) {
            _showNotificationPopup(router, '', payload['message'], payload);
          }
        } catch (e) {
          Log.e('getNotificationToken onMessageReceivedStream - $e');
        }
      },
    );
   final result = await  hw.Push.registerBackgroundMessageHandler(
      registerHuaweiBackground,
    );
    hw.Push.onNotificationOpenedApp.listen((data) {
      _onNotificationClick(data, router);
    });
  }
  else {
    google.FirebaseMessaging.onMessage.listen((data) {
      final notification = data.notification;
      _showNotificationPopup(router, notification?.title ?? '',
          notification?.body ?? '', data.data);
    });
    google.FirebaseMessaging.onBackgroundMessage((data) async {
      _onNotificationClick(data.data, router);
    });
    //notification when app is in foreground
    google.FirebaseMessaging.onMessageOpenedApp.listen((data) {
      _onNotificationClick(data.data, router);
    });
    if (Platform.isIOS) {
      NativeChannelListener.iosNotificationHandler(
        onReceived: (data) {
          try {
            final payload = data['aps'] as Map?;

            final p = payload?.map((k, v) {
              return MapEntry(k.toString(), v);
            });

            if (p?.isNotEmpty == true) {
              _showNotificationPopup(router, '', p?['alert'] ?? '', p ?? {});
            }
          } catch (e) {
            Log.e(
                'apple notification received registerBackgroundMessageHandler - $e');
          }
        },
        onTapped: (data) {
          try {
            final payload = data['aps'] as Map;

            final p = payload.map((k, v) {
              return MapEntry(k.toString(), v);
            });
            if (payload.isNotEmpty) {
              _onNotificationClick(p, router);
            }
          } catch (e) {
            Log.e(
                'apple notification tab registerBackgroundMessageHandler - $e');
          }
        },
      );
    }
  }
}

void registerHuaweiBackground(hw.RemoteMessage message) {
  try {
    final data = message.data;
    final decodedData = jsonDecode(data ?? '{}');
    final payloadList = decodedData['hcm'] as List;
    Map<String, dynamic> payload = {};

    // Iterate over the list and add all key-value pairs to the combined map
    for (var p in payloadList) {
      payload.addAll(p);
    }

    if (payload.isNotEmpty) {
      hw.Push.localNotification(
        <String, String>{
          hw.HMSLocalNotificationAttr.TITLE: payload['title'] ?? '',
          hw.HMSLocalNotificationAttr.MESSAGE: payload['message'] ?? '',
        },
      );
    }
  } catch (e) {
    Log.e('getNotificationToken registerBackgroundMessageHandler - $e');
  }
}

void _showNotificationPopup(GoRouter router, String title, String body,
    Map<String, dynamic> data) async
{
  title = "SGX Notification";
  String? type = data['type'];
  Widget icon = const SizedBox.shrink();

  if (type == 's' || type == 'i') {
    Map<String, dynamic> securityCacheMap = await loadSecurityCache();
    if (securityCacheMap.isEmpty) {
      securityCacheMap = await fetchSecurityMap();
    }
    if (body.contains('decreased')) {
      icon = Image.asset(
        'assets/images/notifications/price_up.png',
        package: 'sgx_online_common',
        fit: BoxFit.fitWidth,
        height: 16,
      );
    } else {
      icon = Image.asset(
        'assets/images/notifications/price_down.png',
        package: 'sgx_online_common',
        fit: BoxFit.fitWidth,
        height: 16,
      );
    }
  } else if (type == 'ipo') {
    icon = Image.asset(
      'assets/images/notifications/ic_ipo_outline.png',
      package: 'sgx_online_common',
      fit: BoxFit.fitWidth,
      height: 16,
    );
  } else if (data['announcement_id'] != null) {
    icon = Image.asset(
      'assets/images/notifications/announcement.png',
      package: 'sgx_online_common',
      fit: BoxFit.fitWidth,
      height: 16,
    );
  }
  showSlideDownPopup(
      context: router.routerDelegate.navigatorKey.currentContext!,
      title: title,
      message: body,
      icon: SizedBox(
        width: 16,
        height: 16,
        child: icon,
      ),
      data: data,
      onClick: (payload) {
        _onNotificationClick(payload, router);
      });
}

void _onNotificationClick(Map<String, dynamic> data, GoRouter router) async {
  final String? code = data['stock_code'];
  final String? type = data['type'];
  final String? announcementId = data['announcement_id'];
  final String? url = data['url'];
  // final String? title = data['title'];
  String? ipoTitle = data['message'];
  if (Platform.isIOS) {
    ipoTitle = data['alert'];
  }
  if (type != null) {
    switch (type) {
      case 's': //security
        {
          if (code != null && code.isNotEmpty) {
            _redirectToSecurity(router: router, code: code);
          }
        }
        break;
      case 'i': //indices
        {
          if (code != null && code.isNotEmpty) {
            _redirectToIndices(router: router, code: code);
          }
        }
      case 'ipo': //ipo notification
        {
          if (ipoTitle != null && url != null) {
            router.pushNamed('upcoming-ipos-details', extra: {
              'title': ipoTitle,
              'url': url,
            });
          }
        }
        break;
      default:
        {
          if (code != null) {
            code.startsWith('.')
                ? _redirectToSecurity(
                    router: router,
                    code: code.substring(1), //remove .
                  )
                : _redirectToIndices(router: router, code: code);
          } else {
            if (announcementId != null && announcementId.isNotEmpty) {
              _redirectToAnnouncement(router: router, id: announcementId);
            } else if (url != null && url.isNotEmpty) {
              router.pushNamed('upcoming-ipos-details', extra: {
                'title': ipoTitle,
                'url': url,
              });
            }
          }
        }
    }
  }
}

void _redirectToSecurity(
    {required GoRouter router, required String code}) async
{
  try {
    Map<String, dynamic> securityCacheMap = await loadSecurityCache();
    if (securityCacheMap.isEmpty) {
      securityCacheMap = await fetchSecurityMap();
    }
    final type = securityCacheMap[code];
    if (type != null) {
      router.pushNamed(
        'security-details',
        pathParameters: {
          'stockType': type.toString(),
          'selectedStock': code,
        },
      );
    } else {
      Log.e('invalid security');
    }
  } catch (e) {
    Log.e("can't redirect $e");
  }
}

void _redirectToIndices({required GoRouter router, required String code}) {
  router.pushNamed(
    'indices-details',
    pathParameters: {
      'selectedStock': code,
    },
  );
}

void _redirectToAnnouncement({required GoRouter router, required String id}) {
  router.pushNamed('/news/announcement-details/$id');
}
