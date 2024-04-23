import 'package:falcon_storage/falcon_storage.dart';
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
  Future<FalconStorage> _getFalconStorage() async {
    await FalconStorage.initInstance();
    return FalconStorage.instance;
  }
  @override
  void saveSessionState({required String session, required String userId}) async {
    FalconStorage storage = await _getFalconStorage();
    storage.setValueSecure(_sessionKey, session);
    storage.setValueSecure(_userIdKey, userId);
  }

  @override
  Future<String> getUserId() async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.getValueSecure(_sessionKey) ?? '';
  }

  @override
  Future<String> getSession() async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.getValueSecure(_sessionKey) ?? '';
  }

  @override
  Future<void> saveDeviceToken({required String uuid}) async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.setValueSecure(_deviceToken, uuid);
  }

  @override
  Future<String> getDeviceToken() async {
    FalconStorage storage = await _getFalconStorage();
    String? deviceToken = await storage.getValueSecure(_deviceToken);
    if (deviceToken == null) {
      await saveDeviceToken(uuid: uuid());
    }
    return (await storage.getValueSecure(_deviceToken)) ?? '';
  }

  @override
  Future<void> savePrivateKey({required String privateKey}) async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.setValueSecure(_privateKey, privateKey);
  }

  @override
  Future<String> getPrivateKey() async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.getValueSecure(_privateKey) ?? '';
  }

  @override
  Future<void> savePublicKey({required String publicKey}) async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.setValueSecure(_publicKey, publicKey);
  }

  @override
  Future<String> getPublicKey() async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.getValueSecure(_publicKey) ?? '';
  }

  @override
  Future<void> saveAnnouncementToken(String announcementToken) async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.setValueSecure(_announcementToken, announcementToken);
  }

  @override
  Future<String> getAnnouncementToken() async {
    FalconStorage storage = await _getFalconStorage();
    return await storage.getValueSecure(_announcementToken) ?? '';
  }

  @override
  Future<void> logout() async {
    FalconStorage storage = await _getFalconStorage();
    storage.clearSecureStoreage();
  }

}
