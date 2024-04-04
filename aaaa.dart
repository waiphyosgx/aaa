 var ameSecurity =  await rootBundle.loadString("assets/js/ame_security_util.js");;
    await _controller?.runJavaScriptReturningResult(ameSecurity);

    final result = await _controller?.runJavaScriptReturningResult('encryptPinForAM("${ame[0]}","${ame[1]}","${ame[2]}","${ame[3]}","${ame[4]}")');
    print('Result: $result'); // Output: Result: 5
