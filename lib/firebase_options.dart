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
    apiKey: 'AIzaSyAucLUF6SbUfp7hCvcLc5vzTPYP7Xs0wUY',
    appId: '1:8862601984:web:7c341500fb2ad1ad57d9e5',
    messagingSenderId: '8862601984',
    projectId: 'chatappsocket',
    authDomain: 'chatappsocket.firebaseapp.com',
    storageBucket: 'chatappsocket.appspot.com',
    measurementId: 'G-3QSBGMRGH8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTbl_18Y_ksJpSrrhlZffxlZ4wjCA1wyU',
    appId: '1:8862601984:android:4a3a846e59ad139657d9e5',
    messagingSenderId: '8862601984',
    projectId: 'chatappsocket',
    storageBucket: 'chatappsocket.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKI5q_YrcCEHoaxOpLrUYUQChL0hYpfvU',
    appId: '1:8862601984:ios:fc3e9c5b1600c6e057d9e5',
    messagingSenderId: '8862601984',
    projectId: 'chatappsocket',
    storageBucket: 'chatappsocket.appspot.com',
    androidClientId: '8862601984-8hpajec2klrqs082t29qcaiplrddd1j7.apps.googleusercontent.com',
    iosClientId: '8862601984-m8bgm9i7hfednldcpe6m4obotsh6e6ju.apps.googleusercontent.com',
    iosBundleId: 'com.example.testsocketchatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKI5q_YrcCEHoaxOpLrUYUQChL0hYpfvU',
    appId: '1:8862601984:ios:fc3e9c5b1600c6e057d9e5',
    messagingSenderId: '8862601984',
    projectId: 'chatappsocket',
    storageBucket: 'chatappsocket.appspot.com',
    androidClientId: '8862601984-8hpajec2klrqs082t29qcaiplrddd1j7.apps.googleusercontent.com',
    iosClientId: '8862601984-m8bgm9i7hfednldcpe6m4obotsh6e6ju.apps.googleusercontent.com',
    iosBundleId: 'com.example.testsocketchatapp',
  );
}
