<intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" />
                <data android:host="www.sgx.com" />
                <data android:pathPrefix="/qr/redirect/mobileapp" />
            </intent-filter>
