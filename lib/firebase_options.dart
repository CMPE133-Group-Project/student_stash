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
    apiKey: 'AIzaSyC2d-zrZgqVWQW55a01tyvEbVOlTkZlqT4',
    appId: '1:316033620599:web:476afecb7ae6a0fe5a8472',
    messagingSenderId: '316033620599',
    projectId: 'studentstash-a0868',
    authDomain: 'studentstash-a0868.firebaseapp.com',
    storageBucket: 'studentstash-a0868.appspot.com',
    measurementId: 'G-8H9BGTVG4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBNd9E1dlpilFyhsvOJlgpaa9MUe2Xt64',
    appId: '1:316033620599:android:e625752de6a846325a8472',
    messagingSenderId: '316033620599',
    projectId: 'studentstash-a0868',
    storageBucket: 'studentstash-a0868.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFJfiwy1AIBoKlQAmRQeTfBiA355nbZcw',
    appId: '1:316033620599:ios:2cfc8936777523895a8472',
    messagingSenderId: '316033620599',
    projectId: 'studentstash-a0868',
    storageBucket: 'studentstash-a0868.appspot.com',
    iosBundleId: 'com.example.studentStash',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFJfiwy1AIBoKlQAmRQeTfBiA355nbZcw',
    appId: '1:316033620599:ios:c34be168e6e97f9d5a8472',
    messagingSenderId: '316033620599',
    projectId: 'studentstash-a0868',
    storageBucket: 'studentstash-a0868.appspot.com',
    iosClientId: '316033620599-4vt627bmstfb9cii1ougnt1megs8tjgb.apps.googleusercontent.com',
    iosBundleId: 'com.example.studentStash.RunnerTests',
  );
}
