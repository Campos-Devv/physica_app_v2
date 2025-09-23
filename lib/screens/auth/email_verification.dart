import 'package:flutter/material.dart';
import 'package:physica_app/screens/auth/forgot_password.dart';
import 'package:physica_app/screens/auth/reset_password.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  // Six controllers for verification code fields
  final List<TextEditingController> _controllers = List.generate(
    6, 
    (index) => TextEditingController()
  );
  
  // Timer for resending code
  bool _canResend = false;
  int _remainingSeconds = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _remainingSeconds = 60;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds > 0) {
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Simulate verification process
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
                      'Verification successful',
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
          
          // Navigate to Reset Password screen
          Navigator.pushReplacement(
            context,
            SlideRightLeft2(
              enterPage: ResetPassword(),
              exitPage: EmailVerification(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Verification failed. Please try again.',
                      style: const TextStyle(color: Colors.white),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: Stack(
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.responsive(6)),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.responsive(8),
                                    vertical: context.responsive(10),
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.whiteColor,
                                    borderRadius: BorderRadius.circular(context.responsive(6)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Title
                                      Text(
                                        'Go back?',
                                        style: TextStyle(
                                          color: context.skyBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      
                                      SizedBox(height: context.responsive(6)),
                                      
                                      // Content
                                      Text(
                                        'If you go back, you\'ll need to request a new verification code.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      
                                      SizedBox(height: context.responsive(10)),
                                      
                                      // Action buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Cancel button
                                          SizedBox(
                                            width: context.widthPercent(25),
                                            height: context.heightPercent(4.5),
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey[200],
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(context.responsive(3)),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: context.responsive(5),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          SizedBox(width: context.responsive(5)),
                                          
                                          // Confirm button
                                          SizedBox(
                                            width: context.widthPercent(25),
                                            height: context.heightPercent(4.5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Close dialog
                                                Navigator.pushReplacement(
                                                  context,
                                                  SlideLeftRight2(
                                                    enterPage: ForgotPassword(),
                                                    exitPage: EmailVerification(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: context.primaryColor,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(context.responsive(3)),
                                                ),
                                              ),
                                              child: Text(
                                                'Go Back',
                                                style: TextStyle(
                                                  color: context.whiteColor,
                                                  fontSize: context.responsive(5),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.skyBlue,
                            size: 28,
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Text(
                              'Verification',
                              style: TextStyle(
                                color: context.skyBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: context.heightPercent(5)),
                    
                    // Email verification icon
                    Container(
                      width: context.responsive(70),
                      height: context.responsive(70),
                      child: Icon(
                        Icons.email_outlined,
                        size: 70,
                        color: context.skyBlue,
                      ),
                    ),
                    
                    SizedBox(height: context.responsive(10)),
                    
                    // Title text
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Verification Code',
                        style: TextStyle(
                          color: context.skyBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: context.responsive(10)),
                    
                    // Description text
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Please enter the 6-digit verification code\nthat was sent to your email.',
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
                    
                    // 6-digit code input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: context.widthPercent(10),
                          height: context.widthPercent(10),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: _controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.skyBlue,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(context.responsive(4)),
                                borderSide: BorderSide(color: context.skyBlue, width: context.responsive(1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(context.responsive(5)),
                                borderSide: BorderSide(color: context.primaryColor, width: context.responsive(1.5)),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    
                    SizedBox(height: context.responsive(20)),
                    
                    // Resend timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: _canResend ? () {
                            _startResendTimer();
                            // Reset fields
                            for (var controller in _controllers) {
                              controller.clear();
                            }
                          } : null,
                          child: Text(
                            _canResend ? "Resend Code" : "Resend in $_remainingSeconds s",
                            style: TextStyle(
                              color: _canResend ? context.skyBlue : context.redColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: context.responsive(20)),
                    
                    // Verify button - Exactly matching the ForgotPassword submit button
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: context.widthPercent(30),
                        height: context.heightPercent(5),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading ? context.primaryColor : context.primaryColor,
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
                            _isLoading ? 'Verifying...' : 'Verify',
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
          
          // Overlay loading state when _isLoading is true
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
    );
  }
}