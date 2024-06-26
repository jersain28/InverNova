
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBWVseUvz41t9SNMp1Ztl28W21Dyx5sXyg',
    authDomain: 'invernova-69060.firebaseapp.com',
    databaseURL: 'https://invernova-69060-default-rtdb.firebaseio.com',
    projectId: 'invernova-69060',
    storageBucket: 'invernova-69060.appspot.com',
    messagingSenderId: '379116688959',
    appId: '1:379116688959:web:a59828de61174544694a8a',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4X0fPlyrid-Hy31ri3rdzkZRG2TvbU-0',
    authDomain: 'invernova-69060.firebaseapp.com',
    databaseURL: 'https://invernova-69060-default-rtdb.firebaseio.com',
    projectId: 'invernova-69060',
    storageBucket: 'invernova-69060.appspot.com',
    messagingSenderId: '379116688959',
    appId: '1:379116688959:android:b5ad9005464c65c5694a8a',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxh5gVGGtozVo_8LrXsimhB--4E0ITAw4',
    authDomain: 'invernova-69060.firebaseapp.com',
    databaseURL: 'https://invernova-69060-default-rtdb.firebaseio.com',
    projectId: 'invernova-69060',
    storageBucket: 'invernova-69060.appspot.com',
    messagingSenderId: '379116688959',
    appId: '1:379116688959:ios:3f86cd078f623292694a8a',
    iosClientId: '379116688959-ek1qa546nm48nf7mphjng006d3hjbd1m.apps.googleusercontent.com',
    iosBundleId: 'com.example.invernova',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxh5gVGGtozVo_8LrXsimhB--4E0ITAw4',
    authDomain: 'invernova-69060.firebaseapp.com',
    databaseURL: 'https://invernova-69060-default-rtdb.firebaseio.com',
    projectId: 'invernova-69060',
    storageBucket: 'invernova-69060.appspot.com',
    messagingSenderId: '379116688959',
    appId: '1:379116688959:ios:be7c956141b259a6694a8a',
    iosClientId: '379116688959-a4raci6nq129sp5pfgk1vepuhsb9omji.apps.googleusercontent.com',
    iosBundleId: 'com.example.invernova.RunnerTests',
  );
}
