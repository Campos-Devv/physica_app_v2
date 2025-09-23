import 'package:flutter/material.dart';
import 'package:physica_app/screens/auth/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    bool isValid = true;
    
    // Validate password - minimum 6 characters without special character requirement
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      isValid = false;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }
    
    // Validate confirm password
    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (confirmPassword != password) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }
    
    return isValid;
  }

  Future<void> _resetPassword() async {
    if (!_validatePassword()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: context.whiteColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Password reset successful!',
                    style: TextStyle(color: context.whiteColor),
                  ),
                ),
              ],
            ),
            backgroundColor: context.primaryColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navigate to sign in screen
        Navigator.pushAndRemoveUntil(
          context,
          SlideLeftRight2(
            enterPage: SignIn(),
            exitPage: ResetPassword(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: context.whiteColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Failed to reset password. Please try again.',
                    style: TextStyle(color: context.whiteColor),
                  ),
                ),
              ],
            ),
            backgroundColor: context.redColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
          ),
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

  InputDecoration getInputDecoration({
    required String hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 14,
      ),
      filled: true,
      fillColor: context.whiteColor,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: context.greyColor,
      ),
      errorText: errorText,
      errorStyle: const TextStyle(
        height: 0.8,
      ),
      isDense: true,
      prefixIcon: Padding(
        padding: EdgeInsets.all(context.responsive(4)),
        child: prefixIcon,
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.all(context.responsive(2)),
        child: suffixIcon,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.responsive(4)),
        borderSide: BorderSide(color: context.skyBlue.withOpacity(1), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.responsive(6)),
        borderSide: BorderSide(color: context.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.responsive(4)),
        borderSide: BorderSide(color: context.redColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.responsive(6)),
        borderSide: BorderSide(color: context.redColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                width: context.widthPercent(100),
                color: context.whiteColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: context.responsive(15) + context.heightPercent(0),
                    left: context.responsive(5) + context.widthPercent(5),
                    right: context.responsive(5) + context.widthPercent(5),
                  ),
                  child: Column(
                    children: [
                      // Replace the back button with a centered title
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: context.heightPercent(5)),
                      
                      // Lock icon using the assets image
                      Image.asset(
                        'assets/icons/key_icon.png',
                        width: context.responsive(70),
                        height: context.responsive(70),
                        color: context.skyBlue,
                      ),
                      
                      SizedBox(height: context.responsive(10)),
                      
                      // Title and instructions
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Create New Password',
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: context.responsive(10)),
                      
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Your new password must be at least 6 characters\nand different from previous passwords',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: context.responsive(20)),
                      
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: getInputDecoration(
                          hintText: 'New Password',
                          errorText: _passwordError,
                          prefixIcon: Image.asset(
                            'assets/icons/lock_icon.png',
                            width: 20,
                            height: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              _isPasswordVisible 
                                  ? 'assets/icons/eye_icon.png'
                                  : 'assets/icons/hide_icon.png',
                              width: 20,
                              height: 20,
                              color: context.skyBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          if (_passwordError != null) {
                            _validatePassword();
                          }
                        },
                      ),
                      
                      SizedBox(height: context.responsive(15)),
                      
                      // Confirm Password field
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: getInputDecoration(
                          hintText: 'Confirm Password',
                          errorText: _confirmPasswordError,
                          prefixIcon: Image.asset(
                            'assets/icons/lock_icon.png',
                            width: 20,
                            height: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              _isConfirmPasswordVisible 
                                  ? 'assets/icons/eye_icon.png'
                                  : 'assets/icons/hide_icon.png',
                              width: 20,
                              height: 20,
                              color: context.skyBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          if (_confirmPasswordError != null) {
                            _validatePassword();
                          }
                        },
                      ),
                      
                      SizedBox(height: context.responsive(20)),
                      
                      // Submit button
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: context.widthPercent(30),
                          height: context.heightPercent(5),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(context.responsive(3))
                                )
                              ),
                              disabledBackgroundColor: context.primaryColor,
                              disabledForegroundColor: context.whiteColor,
                            ),
                            child: Text(
                              _isLoading ? 'Resetting...' : 'Reset Password',
                              style: TextStyle(
                                color: context.whiteColor,
                                fontSize: context.responsive(6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Loading overlay
            if (_isLoading)
              Container(
                width: context.widthPercent(100),
                height: context.heightPercent(100),
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: BouncingDotsLoading(
                    color: context.whiteColor,
                    size: context.heightPercent(10),
                    dotSize: 6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}