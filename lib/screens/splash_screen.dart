import 'package:flutter/material.dart';
import 'package:physica_app/screens/home_screen.dart';
import 'dart:async';
import 'package:physica_app/screens/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to SignIn screen after 3 seconds
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      ),
    );
  }

  void checkAuthState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(
          currentIndex: 0, // Replace with your home screen index
          onTap: (index) {}
        )), // Replace with your home screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor, // Change as needed to match your app theme
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: context.widthPercent(100),
                height: MediaQuery.of(context).size.height,
                color: context.whiteColor, // Background color for the splash screen
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo
                    Image.asset(
                      'assets/images/physica_logo.png', // Make sure to add your logo to assets
                      height: 203,
                      width: 203,
                    ),
                    const SizedBox(height: 20),
                    // App name
                    const Text(
                      'Physica',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Adjust color to match your brand
                      ),
                    ),
                    // Loading indicator
                    const SizedBox(height: 20),
                    
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: context.widthPercent(100),
                height: MediaQuery.of(context).size.height * 0.2,
                child: BouncingDotsLoading(
                  backgroundColor: Colors.transparent,
                  dotSize: 4.0,
                  color: context.skyBlue, // Adjust color to match your brand
                  size: 70.0,
                  message: '',
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}