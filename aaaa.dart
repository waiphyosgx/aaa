import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:falcon_logger/falcon_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as google;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:sgx_online_common/sgx_online_common_utils.dart';
import 'package:sgx_online_common/src/utils/native_utils/price_list_cahce_utils.dart';

final _localNotification = FlutterLocalNotificationsPlugin();
Future<String?> getNotificationToken(GoRouter router) async {
  //for huawei
  if (Platform.isAndroid && await isHmsAvailable()) {
    return Future(() async {
      final Completer<String> completer = Completer<String>();
      bool isGranted = await Push.isAutoInitEnabled();
      if (!isGranted) {
        await Push.setAutoInitEnabled(true);
      }

      Push.getTokenStream.listen((token) {
        if (!completer.isCompleted) {
          completer.complete(token);
        }
      });
      Push.getToken('');

      final complete = await completer.future;
      Push.onMessageReceivedStream.listen(
        (message){
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
                _showNotification('', payload['message'], jsonEncode(payload));
            }
          }
          catch(e){
          }
        },
      );
      Push.registerBackgroundMessageHandler(
        (message){
          try {
            final data = message.data;
            final decodedData = jsonDecode(data ?? '{}');
            final payloadList = decodedData['hcm'] as List;
            Map<String, dynamic> payload = {};

            // Iterate over the list and add all key-value pairs to the combined map
            for (var p in payloadList) {
              payload.addAll(p);
            }

            log('message is received $data');
            if (payload.isNotEmpty) {
              _showNotification('', payload['message'], jsonEncode(payload));
            }
          }
          catch(e){
          }
        },
      );
      Push.onNotificationOpenedApp.listen((data) {
        _onNotificationClick(data, router);
      });

      return complete;
    });

  }
  //for firebase (google android + apple)
  else {
    if (Firebase.apps.isEmpty) {
      //double check for it
      await Firebase.initializeApp();
    }
    google.FirebaseMessaging firebaseMessaging = google.FirebaseMessaging.instance;
    //request noti permission
    await firebaseMessaging.requestPermission();
    //get push token
    final token = await firebaseMessaging.getToken();
    return token;
  }
}

void registerNotification(GoRouter router) async {
  //for deep link and callback
  await _localNotification.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/sgx_logo"),
    ),
    onDidReceiveNotificationResponse: (response) {
      _onNotificationClick(jsonDecode(response.payload ?? '{}'), router);
    },
  );
  //notification when app is not active
  google.FirebaseMessaging.onMessage.listen((data){
     final notification = data.notification;
    _showNotification(notification?.title ?? '', notification?.body ?? '', jsonEncode(data.data));
  });
  google.FirebaseMessaging.onBackgroundMessage((data) async{
    _onNotificationClick(data.data, router);
  });
  //notification when app is in foreground
  google.FirebaseMessaging.onMessageOpenedApp.listen((data) {
    _onNotificationClick(data.data, router);
  });
}

void _showNotification(String title,String body, String data) {
  _localNotification.show(
    data.hashCode,
    title,
    body,
    payload: data, //convert to map
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_important_channel',
        'high_important_notification',
      ),
    ),
  );
}

void _onNotificationClick(Map<String, dynamic> data, GoRouter router) async {
  log('the data is $data');
  final String? code = data['stock_code'];
  final String? type = data['type'];
  final String? announcementId = data['announcement_id'];
  final String? url = data['url'];
  // final String? title = data['title'];
  final String? ipoTitle = data['message'];

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

void _redirectToSecurity({required GoRouter router, required String code}) async {
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
  print('the id is $id');
  router.pushNamed('/news/announcement-details/$id');
}
