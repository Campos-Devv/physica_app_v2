import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physica_app/firebase/auth_service.dart';
import 'package:physica_app/screens/auth/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/logger.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _selectedGender = 'Male';
  String? _selectedStrand;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _lrnController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _lrnError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _strandError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _lrnController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Enhanced form decoration with combined scaling
  InputDecoration getFormDecoration({
    required String hintText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: context.whiteColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: context.space(24, xs: 10, sm: 12, md: 18, lg: 20),
        horizontal: context.space(14, xs: 10, sm: 12, md: 18 , lg: 20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
        ),
        borderSide: BorderSide(
          color: errorText != null ? context.redColor : context.skyBlue,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: errorText != null ? context.redColor : context.secondaryColor,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: context.fontSize(8, xs: 6, sm: 7, md: 8, lg: 10, xl: 12),
        color: context.redColor,
        height: 0.8,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: context.skyBlue.withAlpha(128),
        fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
        fontWeight: FontWeight.w400,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: BoxConstraints(
        maxHeight: context.iconSize(24, xs: 20, sm: 22, md: 24, lg: 28, xl: 32),
        maxWidth: context.space(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48),
      ),
    );
  }

  // Enhanced dropdown decoration
  InputDecoration getDropdownDecoration({String? errorText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: context.space(24, xs: 10, sm: 12, md: 14, lg: 20),
        horizontal: context.space(14, xs: 10, sm: 12, md: 18 , lg: 20),
      ),
      filled: true,
      fillColor: context.whiteColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
        ),
        borderSide: BorderSide(
          color: errorText != null ? context.redColor : context.skyBlue,
          width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          context.radius(4, xs: 3, sm: 4, md: 5, lg: 6),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsiveCombined(1, xs: 0.8, sm: 1.0, md: 1.2, lg: 1.5),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
        ),
        borderSide: BorderSide(
          color: context.secondaryColor,
          width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
        ),
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: context.fontSize(8, xs: 6, sm: 7, md: 8, lg: 10, xl: 12),
        color: context.redColor,
        height: 0.8,
      ),
    );
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
                              top: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                              bottom: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header with back button and title
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            SlideLeftRight2(
                                              enterPage: const SignIn(),
                                              exitPage: const SignUp(),
                                            ),
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
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: context.fontSize(20, xs: 16, sm: 18, md: 16, lg: 24),
                                              fontWeight: FontWeight.w600,
                                              color: context.skyBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: context.space(30, xs: 20, sm: 25, md: 35, lg: 45)),

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
                  backgroundColor: Colors.transparent,
                  size: context.heightPercent(10),
                  dotSize: context.iconSize(6, xs: 3, sm: 4, md: 5, lg: 7, xl: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Form content widget
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name & Last Name Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name',
                    style: TextStyle(
                      fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                      fontWeight: FontWeight.w500,
                      color: context.skyBlue,
                    ),
                  ),
                  SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
                  TextFormField(
                    controller: _firstNameController,
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                    ),
                    minLines: 1,
                    maxLines: 1,
                    decoration: getFormDecoration(
                      hintText: 'Enter your first name',
                      errorText: _firstNameError,
                    ),
                    onChanged: (value) {
                      if (_firstNameError != null) {
                        setState(() => _firstNameError = null);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: context.space(15, xs: 10, sm: 12, md: 15, lg: 18)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                      fontWeight: FontWeight.w500,
                      color: context.skyBlue,
                    ),
                  ),
                  SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
                  TextFormField(
                    controller: _lastNameController,
                    style: TextStyle(
                      color: context.skyBlue,
                      fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                    ),
                    minLines: 1,
                    maxLines: 1,
                    decoration: getFormDecoration(
                      hintText: 'Enter your last name',
                      errorText: _lastNameError,
                    ),
                    onChanged: (value) {
                      if (_lastNameError != null) {
                        setState(() => _lastNameError = null);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // Email Field
        Text(
          'Email',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        TextFormField(
          controller: _emailController,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          keyboardType: TextInputType.emailAddress,
          minLines: 1,
          maxLines: 1,
          decoration: getFormDecoration(
            hintText: 'Enter your email',
            errorText: _emailError,
          ),
          onChanged: (value) {
            if (_emailError != null) {
              setState(() => _emailError = null);
            }
          },
        ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // LRN Field
        Text(
          'LRN',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        TextFormField(
          controller: _lrnController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          minLines: 1,
          maxLines: 1,
          decoration: getFormDecoration(
            hintText: 'Enter your LRN',
            errorText: _lrnError,
          ),
          onChanged: (value) {
            if (_lrnError != null) {
              setState(() => _lrnError = null);
            }

            if (value.isNotEmpty) {
              if (value.length == 12) {
                if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                  setState(() => _lrnError = 'LRN must be exactly 12 digits');
                }
              } else {
                setState(() => _lrnError = 'LRN must be exactly 12 digits (${value.length}/12)');
              }
            }
          },
        ),

        // LRN validation message
        if (_lrnError == null && _lrnController.text.length == 12)
          Padding(
            padding: EdgeInsets.only(
              top: context.space(6, xs: 4, sm: 5, md: 6, lg: 8),
              left: context.space(6, xs: 4, sm: 5, md: 6, lg: 8),
            ),
            child: Text(
              'LRN format valid - uniqueness will be verified by the server',
              style: TextStyle(
                fontSize: context.fontSize(9, xs: 7, sm: 8, md: 9, lg: 11),
                fontStyle: FontStyle.italic,
                color: context.skyBlue.withAlpha(179),
              ),
            ),
          ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // Strand Field
        Text(
          'Strand',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        DropdownButtonFormField<String>(
          decoration: getDropdownDecoration(errorText: _strandError),
          icon: Icon(
            Icons.arrow_drop_down,
            color: context.primaryColor,
            size: context.iconSize(22, xs: 18, sm: 20, md: 22, lg: 26),
          ),
          dropdownColor: context.whiteColor,
          isExpanded: true,
          hint: Text(
            'Select Strand',
            style: TextStyle(
              color: context.skyBlue.withAlpha(128),
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
              fontWeight: FontWeight.w500,
            ),
          ),
          value: _selectedStrand,
          items: ['STEM', 'ABM', 'HUMSS'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: context.skyBlue,
                    fontSize: context.fontSize(12, xs: 8, sm: 9, md: 10, lg: 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStrand = value;
              _strandError = null;
            });
          },
        ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // Gender Selection
        Text(
          'Gender',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  'Male',
                  style: TextStyle(
                    color: context.skyBlue,
                    fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                  ),
                ),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
                activeColor: context.skyBlue,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return context.secondaryColor;
                    }
                    return context.skyBlue;
                  },
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  'Female',
                  style: TextStyle(
                    color: context.skyBlue,
                    fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                  ),
                ),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
                activeColor: context.whiteColor,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return context.secondaryColor;
                    }
                    return context.skyBlue;
                  },
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // Password Field
        Text(
          'Password',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          minLines: 1,
          maxLines: 1,
          decoration: getFormDecoration(
            hintText: 'Enter your password',
            errorText: _passwordError,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: context.space(14, xs: 10, sm: 12, md: 14, lg: 16)),
              child: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: context.skyBlue,
                  size: context.iconSize(20, xs: 16, sm: 18, md: 20, lg: 22),
                ),
              ),
            ),
          ),
          onChanged: (value) {
            if (_passwordError != null) {
              setState(() => _passwordError = null);
            }
          },
        ),

        SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),

        // Confirm Password Field
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
          ),
          minLines: 1,
          maxLines: 1,
          decoration: getFormDecoration(
            hintText: 'Confirm your password',
            errorText: _confirmPasswordError,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: context.space(14, xs: 10, sm: 12, md: 14, lg: 16)),
              child: GestureDetector(
                onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                child: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: context.skyBlue,
                  size: context.iconSize(20, xs: 16, sm: 18, md: 20, lg: 22),
                ),
              ),
            ),
          ),
          onChanged: (value) {
            if (_confirmPasswordError != null) {
              setState(() => _confirmPasswordError = null);
            }
          },
        ),

        SizedBox(height: context.space(30, xs: 20, sm: 25, md: 30, lg: 35)),

        // Sign Up Button
        Center(
          child: SizedBox(
            width:context.buttonWidth(80, xs: 80, sm: 90, md: 140, lg: 140, xl: 150, xxl: 180),
            height: context.buttonHeight(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48, xxl: 52),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
                  ),
                ),
                disabledBackgroundColor: context.primaryColor.withOpacity(0.7),
              ),
              child: Text(
                _isLoading ? 'Creating Account' : 'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.whiteColor,
                  fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: context.space(25, xs: 18, sm: 20, md: 30, lg: 30)),

        // Sign In Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TextStyle(
                color: context.skyBlue,
                fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  SlideLeftRight2(
                    enterPage: const SignIn(),
                    exitPage: const SignUp(),
                  ),
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  // Sign up handler with validation
  Future<void> _handleSignUp() async {
    bool isValid = true;

    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _emailError = null;
      _lrnError = null;
      _strandError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _isLoading = true;
    });

    // Validation logic (keep your existing validation)
    if (_firstNameController.text.isEmpty) {
      setState(() => _firstNameError = 'First name is required');
      isValid = false;
    } else if (RegExp(r'^[0-9]').hasMatch(_firstNameController.text)) {
      setState(() => _firstNameError = 'Cannot start with a number');
      isValid = false;
    } else if (RegExp(r'^[a-z]').hasMatch(_firstNameController.text)) {
      setState(() => _firstNameError = 'First letter should be capitalized');
      isValid = false;
    } else if (!RegExp(r'^[A-Za-z]+$').hasMatch(_firstNameController.text)) {
      setState(() => _firstNameError = 'No special characters');
      isValid = false;
    } else if (_firstNameController.text.length < 2) {
      setState(() => _firstNameError = 'At least 2 letters required');
      isValid = false;
    }

    // Last name validation
    if (_lastNameController.text.isEmpty) {
      setState(() => _lastNameError = 'Last name is required');
      isValid = false;
    } else if (RegExp(r'^[0-9]').hasMatch(_lastNameController.text)) {
      setState(() => _lastNameError = 'Cannot start with a number');
      isValid = false;
    } else if (RegExp(r'^[a-z]').hasMatch(_lastNameController.text)) {
      setState(() => _lastNameError = 'First letter should be capitalized');
      isValid = false;
    } else if (!RegExp(r'^[A-Za-z]+$').hasMatch(_lastNameController.text)) {
      setState(() => _lastNameError = 'No special characters');
      isValid = false;
    } else if (_lastNameController.text.length < 2) {
      setState(() => _lastNameError = 'At least 2 letters required');
      isValid = false;
    }

    // Email validation
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    } else {
      final emailPattern = RegExp(r'^[a-z0-9._%+-]+@gmail\.com$');
      if (!emailPattern.hasMatch(_emailController.text.toLowerCase())) {
        setState(() => _emailError = 'Enter a valid Gmail address');
        isValid = false;
      }
    }

    // LRN validation
    if (_lrnController.text.isEmpty) {
      setState(() => _lrnError = 'LRN is required');
      isValid = false;
    } else if (_lrnController.text.length != 12 || !RegExp(r'^\d{12}$').hasMatch(_lrnController.text)) {
      setState(() => _lrnError = 'LRN must be 12 digits');
      isValid = false;
    }

    // Strand validation
    if (_selectedStrand == null) {
      setState(() => _strandError = 'Strand is required');
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    } else if (!RegExp(r'^[A-Z][a-z]+.*\d.*$').hasMatch(_passwordController.text)) {
      setState(() => _passwordError = 'Password must start with a capital letter, followed by lowercase letters, and contain at least one number');
      isValid = false;
    }

    // Confirm password validation
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'Confirm password is required');
      isValid = false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      isValid = false;
    }

    if (isValid) {
      try {
        final authService = AuthService();

        await authService.registerStudent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          lrn: _lrnController.text,
          strand: _selectedStrand!,
          gender: _selectedGender,
        );

        await authService.signOut();

        setState(() => _isLoading = false);
        _showSuccessDialog(context);
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);
        handleFirebaseAuthError(e);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Enhanced success dialog
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius(8, xs: 6, sm: 7, md: 8, lg: 10)),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(context.space(20, xs: 16, sm: 18, md: 20, lg: 24)),
            decoration: BoxDecoration(
              color: context.whiteColor,
              borderRadius: BorderRadius.circular(context.radius(10, xs: 8, sm: 9, md: 10, lg: 12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: context.responsiveCombined(10, xs: 8, lg: 12),
                  offset: Offset(0.0, context.responsiveCombined(10, xs: 8, lg: 12)),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: context.iconSize(64, xs: 48, sm: 56, md: 64, lg: 72),
                  height: context.iconSize(64, xs: 48, sm: 56, md: 64, lg: 72),
                  child: Image.asset(
                    'assets/icons/success_icon.png',
                    fit: BoxFit.contain,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),
                Text(
                  'Success!',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: context.fontSize(18, xs: 16, sm: 17, md: 18, lg: 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.space(12, xs: 8, sm: 10, md: 12, lg: 16)),
                Text(
                  'Your account has been created successfully. Please sign in with your credentials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.skyBlue,
                    fontSize: context.fontSize(14, xs: 8, sm: 9, md: 10, lg: 12),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                SizedBox(
                  width: context.buttonWidth(80, xs: 80, sm: 90, md: 120, lg: 140, xl: 150, xxl: 180),
                  height: context.buttonHeight(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48, xxl: 52),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        SlideLeftRight2(
                          enterPage: const SignIn(),
                          exitPage: const SignUp(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8, xl: 10, xxl: 10)),
                        ),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: context.whiteColor,
                        fontSize: context.fontSize(14, xs: 8, sm: 9, md: 10, lg: 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Firebase error handler (keep your existing implementation)
  void handleFirebaseAuthError(FirebaseAuthException e) {
    AppLogger.error("Firebase Auth Error", e);

    String errorMessage = "An error occurred during sign up";

    switch (e.code) {
      case 'weak-password':
        errorMessage = 'The password provided is too weak';
        setState(() => _passwordError = errorMessage);
        break;
      case 'email-already-in-use':
        errorMessage = 'An account already exists for that email';
        setState(() => _emailError = errorMessage);
        break;
      case 'invalid-email':
        errorMessage = 'Invalid email address format';
        setState(() => _emailError = errorMessage);
        break;
      case 'lrn-already-exists':
        errorMessage = 'An account with this LRN already exists';
        setState(() => _lrnError = errorMessage);
        break;
      case 'invalid-lrn-format':
        errorMessage = 'LRN must be exactly 12 digits';
        setState(() => _lrnError = errorMessage);
        break;
      case 'permission-denied':
        errorMessage = 'Unable to verify LRN uniqueness. Please try again later.';
        break;
      case 'profile-creation-failed':
        if (e.message != null && e.message!.contains('lrn')) {
          errorMessage = 'An account with this LRN may already exist';
          setState(() => _lrnError = errorMessage);
        } else {
          errorMessage = 'Failed to create your profile. Please try again.';
        }
        break;
      case 'registration-failed':
        errorMessage = 'Registration failed. Please try again.';
        break;
      default:
        errorMessage = 'Error: ${e.message}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: context.iconSize(20, xs: 18, md: 24, lg: 22),
            ),
            SizedBox(width: context.space(10)),
            Expanded(
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.white,
                fontSize: context.fontSize(10, xs: 8, sm: 9, md: 10, lg: 13, xl: 15, xxl: 17),
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
}