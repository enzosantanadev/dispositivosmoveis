// ⚠️  ARQUIVO GERADO PELO FLUTTERFIRE CLI
// Execute: flutterfire configure
// Este arquivo é um PLACEHOLDER — substitua pelos valores do seu projeto Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions não suporta essa plataforma.');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SUBSTITUA cada valor pelo que o FlutterFire CLI gerar para o SEU projeto.
  // ──────────────────────────────────────────────────────────────────────────

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApJN87pfWwpZgWoB3UHAogqMOshG6qAGg',
    appId: '1:871415463001:android:ec8ff7cfb6fbb533894548',
    messagingSenderId: '871415463001',
    projectId: 'memorybox-fa575',
    storageBucket: 'memorybox-fa575.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAWw7fIlfixhvvkQHn-25k7502QWUt24wU',
    appId: '1:871415463001:ios:bca8a34faf3b0022894548',
    messagingSenderId: '871415463001',
    projectId: 'memorybox-fa575',
    storageBucket: 'memorybox-fa575.firebasestorage.app',
    androidClientId: '871415463001-adefgro1dlmmi5b1p6fkg66slf84s7hd.apps.googleusercontent.com',
    iosClientId: '871415463001-09d811s6fcnbtbnbn81llje3tvqn5lds.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapp',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDlCk6wp7VPu_zDGEoIbWRSW16fLXSQZXI',
    appId: '1:871415463001:web:1947c8193dd1836f894548',
    messagingSenderId: '871415463001',
    projectId: 'memorybox-fa575',
    authDomain: 'memorybox-fa575.firebaseapp.com',
    storageBucket: 'memorybox-fa575.firebasestorage.app',
    measurementId: 'G-HP2RH7KTB4',
  );
}
