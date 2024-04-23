// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:falcon_utils/string_utils.dart';
import '../../../sgx_online_common_utils.dart';
import 'session_utils_abstract.dart';

class SessionUtils extends AbstractSessionUtils{
  final _sessionKey = authToken;
  final _userIdKey = cdpUserId;
  final _deviceToken = deviceToken;
  final _privateKey = 'privateKey';
  final _publicKey = 'publicKey';
  final _announcementToken = 'announcementToken';
  @override
  void saveSessionState({required String session, required String userId}) {
    window.sessionStorage[_sessionKey] = session;
    window.sessionStorage[_userIdKey] = userId;
  }

  @override
  Future<String> getUserId() async {
    return window.sessionStorage[_userIdKey] ?? '';
  }

  @override
  Future<String> getSession() async {
    return window.sessionStorage[_sessionKey] ?? '';
  }

  @override
  Future<void> saveDeviceToken({required String uuid}) async {
    window.sessionStorage[_deviceToken] = uuid;
  }

  @override
  Future<String> getDeviceToken() async {
    return window.sessionStorage[_deviceToken] ?? '';
  }

  @override
  Future<void> savePrivateKey({required String privateKey}) async {
    window.sessionStorage[_privateKey] = privateKey;
  }

  @override
  Future<String> getPrivateKey() async {
    return window.sessionStorage[_privateKey] ?? '';
  }

  @override
  Future<void> savePublicKey({required String publicKey}) async {
    window.sessionStorage[_publicKey] = publicKey;
  }

  @override
  Future<String> getPublicKey() async {
    return window.sessionStorage[_publicKey] ?? '';
  }

  @override
  Future<void> saveAnnouncementToken(String announcementToken) async {
    window.sessionStorage[_announcementToken] = announcementToken;
  }

  @override
  Future<String> getAnnouncementToken() async {
    return window.sessionStorage[_announcementToken] ?? '';
  }

  @override
  void logout() {
    window.sessionStorage.remove(_sessionKey);
    window.sessionStorage.remove(_userIdKey);
    window.sessionStorage.remove(_deviceToken);
    window.sessionStorage.remove(_privateKey);
    window.sessionStorage.remove(_announcementToken);
  }

}
