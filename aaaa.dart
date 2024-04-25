val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
        if (binaryMessenger != null) {
            methodChannel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            // Call Flutter after 10 seconds to get the value
            Handler(Looper.getMainLooper()).postDelayed({
                val key = "key1" // Change this to the desired key
                methodChannel.invokeMethod("getValueFromFlutter", key, object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        Toast.makeText(context, result?.toString(), Toast.LENGTH_SHORT).show()
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        Toast.makeText(context, errorMessage?.toString(), Toast.LENGTH_SHORT).show()
                    }

                    override fun notImplemented() {
                        Toast.makeText(context, "good", Toast.LENGTH_SHORT).show()
                    }
                })
            }, 10000)
        } else {
            // Handle the case when binaryMessenger is null
        }
