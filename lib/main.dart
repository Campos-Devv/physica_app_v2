import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physica_app/firebase/firebase_options.dart';
import 'package:physica_app/screens/auth/sign_in.dart';
import 'package:physica_app/screens/navigations/home_screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.authStateChanges});

  final Stream<User?>? authStateChanges;
  
  @override
  Widget build(BuildContext context) {
    final authStream = authStateChanges ?? FirebaseAuth.instance.authStateChanges();
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: _AuthGate(authStateChanges: authStream),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate({required this.authStateChanges});

  final Stream<User?> authStateChanges;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return HomeScreen(
            currentIndex: 0,
            onTap: (_) {},
          );
        }

        return const SignIn();
      },
    );
  }
}