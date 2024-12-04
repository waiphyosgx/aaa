
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.sgx.sgx_online">
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.support.customtabs.action.CustomTabsService" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="mailto" />
  </intent>
</queries>
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <application
        android:label="@string/app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
       <receiver
           android:name="com.huawei.hms.flutter.push.receiver.BackgroundMessageBroadcastReceiver"
           android:exported="false">
           <intent-filter>
               <action android:name="com.huawei.hms.flutter.push.receiver.BACKGROUND_REMOTE_MESSAGE"/>
           </intent-filter>
       </receiver>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
       <meta-data
           android:name="push_kit_auto_init_enabled"
           android:value="true" />

       <meta-data
           android:name="com.huawei.hms.client.channel.androidMarket"
           android:value="false" />
       <meta-data
               android:name="com.facebook.sdk.ApplicationId"
               android:value="@string/facebook_app_id" />
       <meta-data
               android:name="com.facebook.sdk.ClientToken"
               android:value="@string/facebook_client_token" />
       <activity
               android:name="com.facebook.FacebookActivity"
               android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
               android:label="@string/app_name" />
       <activity
               android:name="com.facebook.CustomTabActivity"
               android:exported="true">
           <intent-filter>
               <action android:name="android.intent.action.VIEW" />
               <category android:name="android.intent.category.DEFAULT" />
               <category android:name="android.intent.category.BROWSABLE" />
               <data android:scheme="@string/fb_login_protocol_scheme" />
           </intent-filter>
       </activity>
       <activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity" android:exported="true">
           <intent-filter android:label="flutter_web_auth" android:autoVerify="true">
               <action android:name="android.intent.action.VIEW" />
               <category android:name="android.intent.category.DEFAULT" />
               <category android:name="android.intent.category.BROWSABLE" />
               <data android:scheme="${schemeName}" />
           </intent-filter>
       </activity>
    </application>
    <queries>
        <intent>
            <action android:name="com.huawei.hms.core.aidlservice" />
        </intent>
    </queries>
</manifest>
