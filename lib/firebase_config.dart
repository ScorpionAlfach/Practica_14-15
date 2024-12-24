import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQvP_zeta2Lui-InwtKQMvInGU5iv7Mlkcdk', // Ваш Android API Key
    appId: '1:84707118109:android:xxxxxxxxxxxxxxxx', // Ваш Android App ID
    messagingSenderId: '84707118109', // Ваш Messaging Sender ID
    projectId: 'shopapp-b642c', // Ваш Project ID
    storageBucket: 'shopapp-b642c.appspot.com', // Ваш Storage Bucket
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQvP_zeta2Lui-InwtKQMvInGU5iv7Mlkcdk', // Ваш iOS API Key
    appId: '1:84707118109:ios:xxxxxxxxxxxxxxxx', // Ваш iOS App ID
    messagingSenderId: '84707118109', // Ваш Messaging Sender ID
    projectId: 'shopapp-b642c', // Ваш Project ID
    storageBucket: 'shopapp-b642c.appspot.com', // Ваш Storage Bucket
    iosClientId:
        '84707118109-xxxxxxxxxxxxxxxx.apps.googleusercontent.com', // Ваш iOS Client ID
    iosBundleId: 'com.example.shopapp', // Ваш iOS Bundle ID
  );
}
