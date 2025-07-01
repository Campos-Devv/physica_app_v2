import 'package:flutter/material.dart';
import 'package:physica_app/screens/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: context.primaryColor,
            width: context.widthPercent(100),
            child: Padding(
              padding: EdgeInsets.only(
                top: context.heightPercent(5),
                left: context.widthPercent(10),
                right: context.widthPercent(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context, 
                            SlideLeftRight2(enterPage: const SignIn(),
                              exitPage: const ForgotPassword())
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: context.whiteColor,
                          size: 28,
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'Forgot Password',
                              style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: context.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: context.heightPercent(5),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: context.responsive(5),
                  ),

                  TextField(
                    style: TextStyle(
                      color: context.blackColor,
                      fontSize: context.responsive(7),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: context.blackColor.withAlpha(128),
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: context.responsive(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(4)),
                        ),
                        borderSide: BorderSide.none,
                      ),
                  
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.responsive(6)),
                        ),
                        borderSide: BorderSide(
                          color: context.secondaryColor,
                          width: context.responsive(1.5),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: context.heightPercent(5),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                    
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.redColor,
                        padding: EdgeInsets.symmetric(
                          vertical: context.responsive(1) + context.heightPercent(1),
                          horizontal: context.responsive(4) + context.widthPercent(4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(context.responsive(3),
                          )
                        )
                      )
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          color: context.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}