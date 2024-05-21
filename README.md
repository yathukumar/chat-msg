# Chat-msg project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to Use PhoneVerification 
This class will verify the phone number and OTP , Once the result is success call will return the data in onVerfication member Phone variable.

      PhoneVerification(
        isFirstPage: true,
        enableLogo: false,
        themeColor: Colors.blueAccent,
        backgroundColor: Colors.black,
        initialPageText: "Verify Phone Number",
        initialPageTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textColor: Colors.white,
        onVerification: (Phone? phone) {
          if (phone != null) {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileCreationPage(
                    phone: phone,
                  ),
                ),);
          }
        },
      )
  ## Android Manifest Add below Permission
  
    <uses-feature
    android:name="android.hardware.camera"
    android:required="false" />
    
    <uses-permission android:name="android.permission.READ_CONTACTS"/>
    <uses-permission android:name="android.permission.WRITE_CONTACTS"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    
    <!-- Provide required visibility configuration for API level 30 and above -->
    <queries>
    <!-- For opening files -->
    <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:mimeType="*/*" />
    </intent>
    <!-- If your app checks for SMS support -->
    <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="sms" />
    </intent>
    <!-- If your app checks for call support -->
    <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="tel" />
    </intent>
    </queries>

## What to add in run App

        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await SharedPref.init();
        await IsarDb.init();
        await DeviceStorage.init();
        
