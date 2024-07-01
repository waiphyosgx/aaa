<activity android:name="com.linusu.flutter_web_auth.CallbackActivity" android:exported="true">
           <intent-filter android:label="flutter_web_auth">
               <action android:name="android.intent.action.VIEW" />
               <category android:name="android.intent.category.DEFAULT" />
               <category android:name="android.intent.category.BROWSABLE" />
               <data android:scheme="sgxonline" />
           </intent-filter>
       </activity>
