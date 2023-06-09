// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBLSLCL2-HnLpBhDia8JE7bU-0kVos6zwE',
    appId: '1:464938588234:web:62cca05355a97e69cf6eb3',
    messagingSenderId: '464938588234',
    projectId: 'sotano3',
    authDomain: 'sotano3.firebaseapp.com',
    storageBucket: 'sotano3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALbupz9Jjk-ny65ezbPpIVL2xjAC5GnjU',
    appId: '1:464938588234:android:e745251e317be00ccf6eb3',
    messagingSenderId: '464938588234',
    projectId: 'sotano3',
    storageBucket: 'sotano3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVpJc5BatJXkkhcW1d0g7UtUWW0qCk9TU',
    appId: '1:464938588234:ios:7d244e1465705a9dcf6eb3',
    messagingSenderId: '464938588234',
    projectId: 'sotano3',
    storageBucket: 'sotano3.appspot.com',
    iosClientId: '464938588234-q7ppfm1oelm2vf47ee87fgrp4udnhvt9.apps.googleusercontent.com',
    iosBundleId: 'com.example.sotano3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVpJc5BatJXkkhcW1d0g7UtUWW0qCk9TU',
    appId: '1:464938588234:ios:7d244e1465705a9dcf6eb3',
    messagingSenderId: '464938588234',
    projectId: 'sotano3',
    storageBucket: 'sotano3.appspot.com',
    iosClientId: '464938588234-q7ppfm1oelm2vf47ee87fgrp4udnhvt9.apps.googleusercontent.com',
    iosBundleId: 'com.example.sotano3',
  );
}
