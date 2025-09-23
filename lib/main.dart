import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:physica_app/firebase/firebase_options.dart';
import 'package:physica_app/screens/auth/sign_in.dart';



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
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: SignIn()
    );
  }
}