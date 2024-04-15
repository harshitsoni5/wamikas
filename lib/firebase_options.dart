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
    apiKey: 'AIzaSyBZ6k-JSY7vskogpZgDDREBz6ZRqHsZJgA',
    appId: '1:350187485615:web:71d0574c463a415b86d75a',
    messagingSenderId: '350187485615',
    projectId: 'wamikas-c82b2',
    authDomain: 'wamikas-c82b2.firebaseapp.com',
    storageBucket: 'wamikas-c82b2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlDmwOlgjGVXxLXGE8SbvHs9wu_VcdcSM',
    appId: '1:350187485615:android:f9d20580d8392e6286d75a',
    messagingSenderId: '350187485615',
    projectId: 'wamikas-c82b2',
    storageBucket: 'wamikas-c82b2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBv5FoJzP3QhIPcvmviUr2Z1lx9t2npvus',
    appId: '1:350187485615:ios:3fac0970a333d36086d75a',
    messagingSenderId: '350187485615',
    projectId: 'wamikas-c82b2',
    storageBucket: 'wamikas-c82b2.appspot.com',
    iosBundleId: 'com.example.wamikas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBv5FoJzP3QhIPcvmviUr2Z1lx9t2npvus',
    appId: '1:350187485615:ios:3fac0970a333d36086d75a',
    messagingSenderId: '350187485615',
    projectId: 'wamikas-c82b2',
    storageBucket: 'wamikas-c82b2.appspot.com',
    iosBundleId: 'com.example.wamikas',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZ6k-JSY7vskogpZgDDREBz6ZRqHsZJgA',
    appId: '1:350187485615:web:1ce177918b4c18a286d75a',
    messagingSenderId: '350187485615',
    projectId: 'wamikas-c82b2',
    authDomain: 'wamikas-c82b2.firebaseapp.com',
    storageBucket: 'wamikas-c82b2.appspot.com',
  );
}
