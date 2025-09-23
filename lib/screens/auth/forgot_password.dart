import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physica_app/firebase/auth_service.dart';
import 'package:physica_app/screens/auth/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return false;
    }
    
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      return false;
    }
    
    setState(() {
      _emailError = null;
    });
    return true;
  }

  Future<void> _resetPassword() async {
    final isEmailValid = _validateEmail(_emailController.text.trim());
    
    if (!isEmailValid) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use Firebase Auth's built-in password reset
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim()
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle_outline, 
                  color: Colors.white,
                  size: context.iconSize(20),
                ),
                SizedBox(width: context.space(10)),
                Expanded(
                  child: Text(
                    'Password reset link sent to your email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.fontSize(14),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: context.primaryColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(context.space(16)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radius(8)),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navigate back to SignIn page
        Navigator.pushReplacement(
          context,
          SlideRightLeft2(
            enterPage: SignIn(),
            exitPage: ForgotPassword(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(
          e is FirebaseAuthException 
            ? e.userFriendlyMessage 
            : 'Failed to send reset link. Please try again.'
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Enhanced error snackbar method
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline, 
              color: Colors.white,
              size: context.iconSize(20, xs: 18, lg: 22),
            ),
            SizedBox(width: context.space(10)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.fontSize(14, xs: 12, lg: 16),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(context.space(16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius(10)),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Enhanced InputDecoration with combined scaling
  InputDecoration getInputDecoration({
    required String hintText,
    String? errorText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: context.space(24, xs: 10, sm: 12, md: 18, lg: 20),
        horizontal: context.space(14, xs: 10, sm: 12, md: 18 , lg: 20),
      ),
      filled: true,
      fillColor: context.whiteColor,
      hintText: hintText,
      hintStyle: TextStyle(
        color: context.skyBlue.withAlpha(128),
        fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
        fontWeight: FontWeight.w400
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: context.fontSize(8, xs: 6, sm: 7, md: 8, lg: 10, xl: 12),
        color: context.redColor,
        height: 0.8,
      ),
      isDense: true,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints(
        maxHeight: context.iconSize(24, xs: 20, sm: 22, md: 24, lg: 28, xl: 32),
        maxWidth: context.space(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : context.skyBlue,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : context.skyBlue,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: context.whiteColor,
              width: context.widthPercent(100),
              height: context.heightPercent(100),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: context.safeHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: context.space(30, xs: 20, sm: 25, md: 30, lg: 60, xl: 100),
                              right: context.space(30, xs: 20, sm: 25, md: 30, lg: 60, xl: 100),
                              top: context.space(20, xs: 16, sm: 20, md: 30, lg: 25),
                              bottom: context.space(20, xs: 16, sm: 20, md: 30, lg: 25),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Back button and title
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context, 
                                          SlideLeftRight2(
                                            enterPage: const SignIn(),
                                            exitPage: const ForgotPassword()
                                          )
                                        );
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: context.skyBlue,
                                        size: context.iconSize(28, xs: 18, sm: 20, md: 24, lg: 32),
                                      ),
                                    ),
                                    
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            fontSize: context.fontSize(20, xs: 12, sm: 14, md: 16, lg: 24, xl: 26),
                                            fontWeight: FontWeight.w600,
                                            color: context.skyBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: context.space(40, xs: 25, sm: 30, md: 35, lg: 45)),

                                // Center form on larger screens
                                if (context.isLgAndUp)
                                  Center(
                                    child: SizedBox(
                                      width: context.breakpoint(
                                        lg: 400,
                                        xl: 450,
                                        xxl: 500,
                                        fallback: double.infinity,
                                      ),
                                      child: _buildFormContent(),
                                    ),
                                  )
                                else
                                  _buildFormContent(),

                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Enhanced loading overlay
          if (_isLoading)
            Container(
              width: context.widthPercent(100),
              height: context.heightPercent(100),
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: BouncingDotsLoading(
                  color: context.whiteColor,
                  dotSize: context.iconSize(6, xs: 3, sm: 4, md: 5, lg: 7, xl: 8),
                  size: context.heightPercent(10),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Form content widget for better organization
  Widget _buildFormContent() {
    return Column(
      children: [
        // Logo/Icon
        Align(
          alignment: Alignment.center,
          child: Container(
            width: context.iconSize(70, xs: 50, sm: 80, md: 120, lg: 140, xl: 150),
            height: context.iconSize(70, xs: 50, sm: 80, md: 120, lg: 140, xl: 150),
            child: Image.asset(
              'assets/icons/unlock_icon.png',
              fit: BoxFit.contain,
              color: context.skyBlue,
            ),
          ),
        ),
        
        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 30, lg: 25)),
        
        // Main title
        Align(
          alignment: Alignment.center,
          child: Text(
            'Did you forget your password?',
            style: TextStyle(
              color: context.skyBlue,
              fontSize: context.fontSize(18, xs: 14, sm: 16, md: 18, lg: 22, xl: 24),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: context.space(15, xs: 10, sm: 12,  md: 20, lg: 30)),

        // Description text
        Align(
          alignment: Alignment.center,
          child: Text(
            'Don\'t worry! It happens. Please enter the email\naddress associated with your account to receive a password reset link.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.skyBlue,
              fontSize: context.fontSize(12, xs: 9, sm: 10, md: 11, lg: 14, xl: 16),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        SizedBox(height: context.space(30, xs: 20, sm: 25, md: 40, lg: 50)),

        // Email input field
        TextField(
          controller: _emailController,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(12, xs: 10, sm: 11, md: 10, lg: 14),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => _validateEmail(value),
          decoration: getInputDecoration(
            hintText: 'Enter your email',
            errorText: _emailError,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: context.space(14, xs: 10, sm: 10, md: 12, lg: 16)),
              child: Icon(
                Icons.email_outlined,
                color: context.skyBlue,
                size: context.iconSize(20, xs: 16, md: 18, lg: 22),
              ),
            ),
          ),
        ),
        
        // Add extra space when error is present
        SizedBox(
          height: _emailError != null 
            ? context.space(25, xs: 18, md: 24, lg: 30) 
            : context.space(20, xs: 15, md: 30, lg: 40),
        ),

        // Reset button
        Center(
          child: SizedBox(
            width: context.buttonWidth(120, xs: 100, sm: 110, md: 120, lg: 140, xl: 160),
            height: context.buttonHeight(44, xs: 38, sm: 40, md: 44, lg: 48),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.radius(6, xs: 4, sm: 5, lg: 8))
                  )
                ),
                disabledBackgroundColor: context.primaryColor.withOpacity(0.7),
                disabledForegroundColor: context.whiteColor,
              ),
              child: Text(
                _isLoading ? 'Sending...' : 'Submit',
                style: TextStyle(
                  color: context.whiteColor,
                  fontSize: context.fontSize(14, xs: 12, sm: 13, md: 14, lg: 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}