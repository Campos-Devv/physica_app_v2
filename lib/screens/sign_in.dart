import 'package:flutter/material.dart';
import 'package:physica_app/screens/home_screen.dart';
import 'package:physica_app/screens/sign_up.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: SafeArea(
        child: Container(
          color: context.whiteColor,
          width: context.widthPercent(100),
          // Add this to ensure the container takes all available height
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: context.responsive(5) + context.widthPercent(5),
                right: context.responsive(5) + context.widthPercent(5),
                top: context.responsive(15) + context.heightPercent(0),
                // Add bottom padding
                bottom: context.responsive(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: context.responsive(90),
                      height: context.responsive(90),
                      child: Image.asset(
                        'assets/images/physica_logo.png',
                        fit: BoxFit.contain,
                        color: context.skyBlue, // Ensure the logo is visible
                      ),
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(10),
                  ),
          
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome to Physica',
                      style: TextStyle(
                        color: context.skyBlue,
                        fontSize:20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(30),
                  ),
          
                  Text(
                    'Email',
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(
                    height: context.responsive(5),
                  ),
          
                  TextField(
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.responsive(5),
                        horizontal: context.responsive(10)
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: context.skyBlue.withAlpha(128),
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                      
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.skyBlue,
                          width: context.responsive(1)
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(4))
                        ),
                      ),
          
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(6))
                        ),
                        borderSide: BorderSide(
                          color: context.skyBlue,
                          width: context.responsive(1.5)
                        )
                      ),
                      
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(7),
                  ),
          
                  Text(
                    'Password',
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: context.responsive(5),
                  ),
          
                  TextField(
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.responsive(5),
                        horizontal: context.responsive(10)
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                        color: context.skyBlue.withAlpha(128),
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                      
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.skyBlue,
                          width: context.responsive(1)
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(4))
                        ),
                      ),
          
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(6))
                        ),
                        borderSide: BorderSide(
                          color: context.skyBlue,
                          width: context.responsive(1.5)
                        )
                      ),
                      
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(7),
                  ),
          
                  GestureDetector(
                    onTap: () {
          
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: context.responsive(4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(20),
                  ),
          
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: context.widthPercent(30),
                      height: context.heightPercent(5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            SlideRightLeft2(enterPage: HomeScreen(
                              currentIndex: 0,
                              onTap: (index) {},
                            ), exitPage: SignIn()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(3),
                              )
                            )
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: context.whiteColor,
                            fontSize: context.responsive(6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(10),
                  ),
          
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: context.widthPercent(30),
                      height: context.heightPercent(5),
                      child: ElevatedButton(
                        onPressed: () {
                      
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.skyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(3),
                              )
                            )
                          ),
                        ),
                        child: Text(
                          'Guess Mode',
                          textAlign:  TextAlign.center,
                          style: TextStyle(
                            color: context.whiteColor,
                            fontSize:  context.responsive(5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          
                  SizedBox(
                    height: context.responsive(20),
                  ),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: context.skyBlue,
                          fontSize: context.responsive(5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      SizedBox(
                        width: context.responsive(1),
                      ),
          
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            SlideRightLeft2(enterPage: SignUp(), exitPage: SignIn()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: context.primaryColor,
                            fontSize: context.responsive(5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}