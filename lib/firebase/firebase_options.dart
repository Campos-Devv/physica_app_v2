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
      return web; // Return empty web config instead of throwing error
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can create these using the FlutterFire CLI.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can create these using the FlutterFire CLI.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can create these using the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can create these using the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Replace these values with the ones from your google-services.json file
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZCZ7gzSk5-fcqMvT0kaQZk27JVYKhWWc',
    appId: '1:441474208790:android:9115a78e48f5f3280f1137',
    messagingSenderId: '441474208790',
    projectId: 'physica-app-c718b',
    storageBucket: 'physica-app-c718b.firebasestorage.app',
  );

  // Add an empty web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZCZ7gzSk5-fcqMvT0kaQZk27JVYKhWWc',
    appId: '1:441474208790:web:9115a78e48f5f3280f1137', // Note: this is a placeholder
    messagingSenderId: '441474208790',
    projectId: 'physica-app-c718b',
    storageBucket: 'physica-app-c718b.appspot.com',
  );
}