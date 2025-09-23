import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:physica_app/screens/navigations/home_screen.dart';
import 'package:physica_app/screens/auth/sign_up.dart';
import 'package:physica_app/screens/auth/forgot_password.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart'; // Uses MediaQueryX extension
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';
import 'package:physica_app/utils/logger.dart';
import 'package:physica_app/firebase/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Field error messages (null = no error)
  String? _emailError;
  String? _passwordError;

  // UI state flags
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Authentication service abstraction
  final AuthService _authService = AuthService();

  // Email validation (format + presence)
  bool _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return false;
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  // Password validation (length + pattern rules)
  bool _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return false;
    }
    if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      return false;
    }
    // Rules: starts uppercase, contains lowercase + digit
    final hasUpperStart = RegExp(r'^[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    if (!hasUpperStart || !hasLowerCase || !hasDigit) {
      setState(() => _passwordError =
          'Password must start with uppercase, contain lowercase and numbers');
      return false;
    }
    setState(() => _passwordError = null);
    return true;
  }

  // Sign-in flow: validate -> attempt auth -> navigate or show errors
  Future<void> _signIn() async {
    final emailValid = _validateEmail(_emailController.text.trim());
    final passValid = _validatePassword(_passwordController.text);
    if (!emailValid || !passValid) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        SlideRightLeft2(
          enterPage: HomeScreen(currentIndex: 0, onTap: (i) {}),
            exitPage: const SignIn(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _handleAuthError(e);
    } catch (e) {
      AppLogger.error("Unexpected error during sign in", e);
      if (!mounted) return;
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Centralized FirebaseAuthException -> UI mapping
  void _handleAuthError(FirebaseAuthException e) {
    AppLogger.error("Handling auth error: ${e.code}", e);
    setState(() {
      _emailError = null;
      _passwordError = null;

      if (e.isAccountStatusError) {
        _emailError = 'Account status: ${e.accountStatus}';
        Future.microtask(() => _showAccountStatusError(e.accountStatus));
        return;
      }
      if (e.emailFieldError != null) _emailError = e.emailFieldError;
      if (e.passwordFieldError != null) _passwordError = e.passwordFieldError;

      if (e.code == 'user-not-found') _emailError = 'No account found with this email';
      if (e.code == 'wrong-password') _passwordError = 'Incorrect password';
    });

    if (!e.isAccountStatusError) {
      _showErrorSnackBar(e.userFriendlyMessage);
    }
    AppLogger.info(
        "Auth error applied - Email error: ${_emailError != null}, Password error: ${_passwordError != null}");
  }

  // Dialog for special account status conditions
  void _showAccountStatusError(String status) {
    String title;
    String message;
    Color iconColor;
    switch (status) {
      case 'inactive':
        title = 'Account Inactive';
        message = 'Your account is currently inactive. Please contact your administrator to reactivate it.';
        iconColor = Colors.orange;
        break;
      case 'suspended':
        title = 'Account Suspended';
        message = 'Your account has been suspended. Please contact your administrator for assistance.';
        iconColor = Colors.red;
        break;
      case 'transferred':
        title = 'Account Transferred';
        message = 'Your account has been marked as transferred. Contact your administrator if this is an error.';
        iconColor = Colors.blue;
        break;
      case 'graduated':
        title = 'Account Graduated';
        message = 'Your account is marked as graduated. Contact your administrator if you still need access.';
        iconColor = Colors.green;
        break;
      default:
        title = 'Account Status Issue';
        message = 'There is an issue with your account status. Please contact your administrator.';
        iconColor = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius(12, xs: 8, sm: 10, md: 12, lg: 16, xl: 20)),
        ),
        icon: Image.asset(
          'assets/icons/profile_icon.png',
          color: iconColor,
          width: context.iconSize(48, xs: 32, sm: 40, md: 48, lg: 56, xl: 64),
          height: context.iconSize(48, xs: 32, sm: 40, md: 48, lg: 56, xl: 64),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: context.blackColor,
            fontSize: context.fontSize(18, xs: 14, sm: 16, md: 18, lg: 20, xl: 22),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(
            color: context.blackColor,
            fontSize: context.fontSize(14, xs: 10, sm: 12, md: 14, lg: 16, xl: 18),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.justify,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(40, xs: 24, sm: 32, md: 40, lg: 50, xl: 60),
                  vertical: context.space(12, xs: 8, sm: 10, md: 12, lg: 14, xl: 16),
                ),
                backgroundColor: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius(7, xs: 5, sm: 6, md: 7, lg: 9, xl: 11)),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.fontSize(16, xs: 12, sm: 14, md: 16, lg: 18, xl: 20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced snackbar with combined scaling
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline, 
              color: Colors.white,
              size: context.iconSize(32, xs: 16, sm: 18, md: 20, lg: 24),
            ),
            SizedBox(width: context.space(10)),
            Expanded(
              child: Text(
                message, 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.fontSize(10, xs: 12, lg: 16),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(context.space(25)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius(8)),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Enhanced InputDecoration with combined scaling
  InputDecoration getInputDecoration({
    required String hintText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: context.space(16, xs: 10, sm: 16, md: 18, lg: 20, xl: 20),
        horizontal: context.space(14, xs: 10, sm: 16, md: 18, lg: 20, xl: 20),
      ),
      filled: true,
      fillColor: context.whiteColor,
      hintText: hintText,
      hintStyle: TextStyle(
        color: context.skyBlue.withAlpha(128),
        fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
        fontWeight: FontWeight.w400,
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: context.fontSize(8, xs: 6, sm: 7, md: 8, lg: 10, xl: 12),
        color: Colors.red,
        height: 1.5,
      ),
      isDense: true,
      suffixIcon: suffixIcon,
      suffixIconConstraints: BoxConstraints(
        maxHeight: context.iconSize(24, xs: 20, sm: 22, md: 24, lg: 28, xl: 32),
        maxWidth: context.space(40, xs: 36, sm: 38, md: 40, lg: 44, xl: 48),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : context.skyBlue,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 4, sm: 6, md: 8, lg: 10, xl: 11)),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 6, sm: 8, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: errorText != null ? Colors.red : context.skyBlue,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 4, sm: 6, md: 8, lg: 10, xl: 11)),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 6, sm: 8, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor, // Brand color behind SafeArea
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: context.whiteColor,
              width: context.widthPercent(100),
              height: context.heightPercent(100),
              child: Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    // Enhanced padding with combined scaling
                    padding: EdgeInsets.only(
                      left: context.space(30, xs: 18, sm: 25, md: 30, lg: 60, xl: 100),
                      right: context.space(30, xs: 18, sm: 25, md: 30, lg: 60, xl: 100),
                      top: context.space(30, xs: 16, sm: 20, md: 30, lg: 40),
                      bottom: context.space(30, xs: 16, sm: 20, md: 30, lg: 40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.space(30, xs: 15, sm: 20, md: 25, lg: 35)),
                        
                        // Logo - enhanced proportional sizing
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: context.iconSize(150, xs: 140, sm: 160, md: 180, lg: 180, xl: 200),
                            height: context.iconSize(150, xs: 140, sm: 160, md: 180, lg: 180, xl: 200),
                            child: Image.asset(
                              'assets/images/physica_logo.png',
                              fit: BoxFit.contain,
                              color: context.skyBlue,
                            ),
                          ),
                        ),
                        SizedBox(height: context.space(30, xs: 15, sm: 20, md: 30, lg: 35)),
                        
                        // Title - enhanced font scaling
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Welcome to Physica',
                            style: TextStyle(
                              color: context.skyBlue,
                              fontSize: context.fontSize(18, xs: 14, sm: 16, md: 18, lg: 24, xl: 28, xxl: 32),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: context.space(30, xs: 20, sm: 25, md: 30, lg: 35)),

                        // Center form on larger screens
                        if (context.isLgAndUp)
                          Center(
                            child: SizedBox(
                              width: context.breakpoint(
                                lg: 350,
                                xl: 400,
                                xxl: 450,
                                fallback: double.infinity,
                              ),
                              child: _buildFormContent(),
                            ),
                          )
                        else
                          _buildFormContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Enhanced loading overlay
          if (_isLoading)
            Container(
              width: context.widthPercent(100),
              height: context.heightPercent(100),
              color: Colors.black54,
              child: BouncingDotsLoading(
                color: context.whiteColor,
                dotSize: context.iconSize(6, xs: 3, sm: 4, md: 5, lg: 7, xl: 8),
                size: context.heightPercent(5),
              ),
            ),
        ],
      ),
    );
  }

  // Enhanced form content with combined scaling
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email section - enhanced font scaling
        Text(
          'Email',
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.space(10, xs: 8, sm: 10, md: 12, lg: 14)),
        
        TextField(
          controller: _emailController,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: _validateEmail,
          decoration: getInputDecoration(
            hintText: 'Enter your email',
            errorText: _emailError,
          ),
        ),
        SizedBox(height: context.space(10, xs: 16, sm: 18, md: 20, lg: 24)),

        // Password section - enhanced font scaling
        Text(
          'Password',
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.space(10, xs: 8, sm: 10, md: 12, lg: 14)),
        
        TextField(
          controller: _passwordController,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          obscureText: _obscurePassword,
          onChanged: _validatePassword,
          textAlignVertical: TextAlignVertical.center,
          decoration: getInputDecoration(
            hintText: 'Enter your password',
            errorText: _passwordError,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: context.space(14, xs: 16, sm: 16, md: 18, lg: 20)),
              child: InkWell(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                borderRadius: BorderRadius.circular(context.radius(4, xs: 3, lg: 5)),
                child: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: context.skyBlue,
                  size: context.iconSize(18, xs: 14, sm: 16, md: 18, lg: 20, xl: 22),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.space(10, xs: 7, sm: 8, md: 9, lg: 12)),

        // Forgot password link - enhanced font scaling
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              SlideRightLeft2(
                enterPage: const ForgotPassword(),
                exitPage: const SignIn(),
              ),
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: context.space(30, xs: 20, sm: 25, md: 30, lg: 35)),

        // Enhanced buttons section with breakpoint-specific layouts
        // Always column layout (all breakpoints)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoginButton(),
            SizedBox(height: context.space(20, xs: 14, sm: 16, md: 18, lg: 20, xl: 24)),
            _buildGuestButton(),
          ],
        ),

        SizedBox(height: context.space(50, xs: 25, sm: 30, md: 50, lg: 60)),

        // Sign up hint - enhanced font scaling
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                color: context.skyBlue,
                fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: context.space(4, xs: 2, lg: 6)),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  SlideRightLeft2(
                    enterPage: SignUp(),
                    exitPage: const SignIn(),
                  ),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Enhanced responsive Login button with button height scaling
  Widget _buildLoginButton() {
    return Center(
      child: SizedBox(
        width:context.buttonWidth(80, xs: 80, sm: 100, md: 120, lg: 140, xl: 150, xxl: 180),
        height: context.buttonHeight(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48, xxl: 52),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _signIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isLoading ? context.skyBlue : context.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8, xl: 10, xxl: 10)),
              ),
            ),
          ),
          child: Text(
            _isLoading ? 'Logging In' : 'Login',
            style: TextStyle(
              color: context.whiteColor,
              fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced responsive Guest button with button height scaling
  Widget _buildGuestButton() {
    return Center(
      child: SizedBox(
        width: context.buttonWidth(80, xs: 80, sm: 100, md: 120, lg: 120, xl: 150, xxl: 180),
        height: context.buttonHeight(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48, xxl: 52),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              SlideRightLeft2(
                enterPage: HomeScreen(currentIndex: 0, onTap: (index) {}),
                exitPage: const SignIn(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.skyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8, xl: 10, xxl: 10)),
              ),
            ),
          ),
          child: Text(
            'Guest Mode',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.whiteColor,
              fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}