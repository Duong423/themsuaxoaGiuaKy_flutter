// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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
    apiKey: 'AIzaSyB7ox3hLR-Ru5-RtQIVvDy4iOXR9INLw3I',
    appId: '1:480352562582:web:7dd26d004387c5c09dc1b7',
    messagingSenderId: '480352562582',
    projectId: 'demogk-b80da',
    authDomain: 'demogk-b80da.firebaseapp.com',
    storageBucket: 'demogk-b80da.appspot.com',
    measurementId: 'G-1XL9TQJQMM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaIKeRqDNMaJWDpCYcnCu4RwRNRHh5Wp0',
    appId: '1:480352562582:android:37e99772c0ea982b9dc1b7',
    messagingSenderId: '480352562582',
    projectId: 'demogk-b80da',
    storageBucket: 'demogk-b80da.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-V2SoBr2N6UnPKg3yf1so9rvfUE01Uh0',
    appId: '1:480352562582:ios:bd3d15def2e077f59dc1b7',
    messagingSenderId: '480352562582',
    projectId: 'demogk-b80da',
    storageBucket: 'demogk-b80da.appspot.com',
    iosBundleId: 'com.example.appGk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-V2SoBr2N6UnPKg3yf1so9rvfUE01Uh0',
    appId: '1:480352562582:ios:bd3d15def2e077f59dc1b7',
    messagingSenderId: '480352562582',
    projectId: 'demogk-b80da',
    storageBucket: 'demogk-b80da.appspot.com',
    iosBundleId: 'com.example.appGk',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7ox3hLR-Ru5-RtQIVvDy4iOXR9INLw3I',
    appId: '1:480352562582:web:fe715d828a74547f9dc1b7',
    messagingSenderId: '480352562582',
    projectId: 'demogk-b80da',
    authDomain: 'demogk-b80da.firebaseapp.com',
    storageBucket: 'demogk-b80da.appspot.com',
    measurementId: 'G-BZQF185Z1Y',
  );
}
