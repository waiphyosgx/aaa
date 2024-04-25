   private suspend fun getStorageValue(key: String): String {
        val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
        var storageValue = ""
        return suspendCoroutine {
            if (binaryMessenger != null) {
                methodChannel = MethodChannel(binaryMessenger, channel)
                // Call Flutter after 10 seconds to get the value
                methodChannel.invokeMethod(
                    "getValueFromFlutter",
                    key,
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            storageValue = result.toString()
                            Logger.d("result is getting $storageValue")
                            it.resume(storageValue)
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            it.resume("")
                        }

                        override fun notImplemented() {
                            it.resume("")
                        }
                    })
            }
            else{
                it.resume("")
            }
        }
    }
