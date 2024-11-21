import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:open_file/open_file.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> exportToExcel(List<List<dynamic>> rows, String? fileName) async {
  String csv = const ListToCsvConverter().convert(rows);
  final bytes = utf8.encode(csv);
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/${fileName ?? 'export'}.csv');
  await file.writeAsBytes(bytes);
  if (Platform.isAndroid) {
    _downloadForAndroid(bytes, '${fileName ?? 'export'}.csv', file.path);
  }
  else{
    Share.shareFiles([file.path]);
  }
}

Future<void> _downloadForAndroid(
    List<int> data, String fileName, String internalPath) async {
  var status = await Permission.storage.request();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final android = await deviceInfoPlugin.androidInfo;
  if (status.isGranted || android.version.sdkInt >= 33) {
    Directory? downloadDirectory = Directory('/storage/emulated/0/Download');
    if (!await downloadDirectory.exists()) {
      downloadDirectory = await getExternalStorageDirectory();
    }
    if (downloadDirectory != null) {
      String filePath = '${downloadDirectory.path}/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(data);

      // Show notification using NotificationManager
      await _initializeNotifications(internalPath);
      _showNotification(fileName, internalPath);
    } else {
      Share.shareFiles([internalPath]);
    }
  } else {
    Share.shareFiles([internalPath]);
  }
}

Future<void> _initializeNotifications(String filePath) async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      _handleNotificationClick(filePath);
    },
  );
}

Future<void> _showNotification(String fileName, String filePath) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id', // Unique channel ID
    'channel_name', // Channel name
    channelDescription: 'Channel description',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'File download successfully', // Notification Title
    fileName, // Notification Body
    payload: filePath, // Optional payload
    notificationDetails,
  );
}

void _handleNotificationClick(String payload) async {
  OpenFile.open(
    payload,
    type: "text/plain",
    linuxUseGio: true,
    linuxByProcess: false,
  ).catchError((e) {
    //
  }).whenComplete((){
    Share.shareFiles([payload]);
  });
}
