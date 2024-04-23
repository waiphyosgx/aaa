abstract class AbstractSessionUtils {
  void saveSessionState({required String session, required String userId});
  Future<String> getUserId();
  Future<String> getSession();
  Future<void> saveDeviceToken({required String uuid});
  Future<String> getDeviceToken();
  Future<void> savePrivateKey({required String privateKey});
  Future<String> getPrivateKey();
  Future<void> savePublicKey({required String publicKey});
  Future<String> getPublicKey();
  Future<void> saveAnnouncementToken(String announcementToken);
  Future<String> getAnnouncementToken();
  void logout();
}