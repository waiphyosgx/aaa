import 'dart:io';
import 'package:falcon_bootstrap/falcon_bootstrap.dart';
import 'package:falcon_utils/string_utils.dart';
import 'package:sgx_online_common/sgx_online_common_services.dart';
import 'package:xml/xml.dart';

import '../../../sgx_online_common_utils.dart';
//create the keys and report app for the first time
SessionUtils sessionUtils = SessionUtils();

Future<void> sessionMobileInit() async{
  if(Platform.isAndroid || Platform.isIOS){
    try{
      final oldSharedPrefPath = await _getNativeSharedPreferencesPath();
      File file = File(oldSharedPrefPath);
      if(file.existsSync()){
        String contents = await file.readAsString();
        final document = XmlDocument.parse(contents);
        Map<String, dynamic> nativePreferencesValue = {};
        Iterable<XmlElement> elements = document.rootElement.children.whereType<XmlElement>();
        for (XmlElement element in elements) {
          String key = element.getAttribute('name') ?? '';
          String value = element.value ?? '';
          nativePreferencesValue[key] = value; // Store as string by default
        }
        String? syncPublicKey;
        String? deviceId;
        String? gcmKey;
        bool? tokenPush;
        if(Platform.isAndroid){
          syncPublicKey = nativePreferencesValue['SYNC_PUB_KEY'];
          deviceId = nativePreferencesValue['DEVICE_ID'];
          gcmKey = nativePreferencesValue['GCM'];
          tokenPush = nativePreferencesValue['TOKEN_PUSH'];
        }
        else if(Platform.isIOS){
          //TODO('read the native value from ios')
        }
        if(syncPublicKey != null){
          await sessionUtils.savePublicKey(publicKey: syncPublicKey);
        }
        else{
          //create key
          await sessionUtils.getPublicKey();
        }
        if(deviceId != null){
          await sessionUtils.saveDeviceToken(uuid: deviceToken);
        }
        else{
          await sessionUtils.saveDeviceToken(uuid: uuid());
        }
      }
    }
    catch(e){
      //
    }
  }

}

Future<String> _getNativeSharedPreferencesPath() async{
  if(Platform.isAndroid){
    Directory directory =  Directory('/data/user/0/com.sgx.SGXandroid');
    //android shared preference location
    String sharedPreferenceLocation = '${directory.path}/shared_prefs/SGX_SHARED_PREFERENCES.xml';
    return sharedPreferenceLocation;
  }
  else if(Platform.isIOS){
    //TODO(to do for NS user default)
    return '';
  }
  else {
    return throw Exception('unsupported platform');
  }
}