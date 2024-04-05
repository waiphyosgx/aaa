class AmeHelper {
  encryptPinForAM(List args) async{
    WebViewController myController = WebViewController();
    myController.setJavaScriptMode(JavaScriptMode.unrestricted);
    String ameSecurity =  await rootBundle.loadString("packages/sgx_online_login/assets/js/ame_security_util.js");
    await myController.runJavaScript(ameSecurity);
    final result = await myController.runJavaScriptReturningResult('encryptPinForAM("${args[0]}","${args[1]}","${args[2]}","${args[3]}","${args[4]}")');
    return result;
  }
} 
