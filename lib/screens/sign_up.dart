import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physica_app/screens/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  String  _selectedGender = 'Male';
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

  InputDecoration getFormDecoration({
    required String hintText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: context.whiteColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: context.responsive(5),
        horizontal: context.responsive(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.responsive(4)),
        ),
        borderSide: BorderSide(
          color: context.skyBlue,
          width: context.responsive(1),
        ),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.responsive(4)),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsive(1),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(context.responsive(6)),
        ),
        borderSide: BorderSide(
          color: context.redColor,
          width: context.responsive(1.5),
        ),
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: 9, // Make error text smaller
        color: context.redColor,
        height: 0.8, // Reduce the line height
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: context.skyBlue.withAlpha(128),
        fontSize: 12,
      ),
      suffixIcon: suffixIcon,
    );
  }

  InputDecoration getDropdownDecoration({String? errorText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: context.responsive(5),
        horizontal: context.responsive(10),
      ),
      filled: true,
      fillColor: context.whiteColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          context.responsive(4),
        ),
        borderSide: BorderSide(
          color: context.skyBlue,
          width: context.responsive(1),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          context.responsive(4),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: context.responsive(1),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          context.responsive(6),
        ),
        borderSide: BorderSide(
          color: Colors.red,
          width: context.responsive(1.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          context.responsive(6),
        ),
        borderSide: BorderSide(
          color: context.secondaryColor,
          width: context.responsive(1.5),
        ),
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: 9,
        color: Colors.red,
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
            child: SingleChildScrollView(
              child: Container(
                width: context.widthPercent(100),
                color: context.whiteColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.responsive(5) + context.widthPercent(5),
                    right: context.responsive(5) + context.widthPercent(5),
                    top: context.responsive(15) + context.heightPercent(0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context, 
                                  SlideLeftRight2(enterPage: const SignIn(),
                                    exitPage: const SignUp())
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
                                  'Sign Up',
                                    style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: context.skyBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(5),
                        ),
                    
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'First Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: context.skyBlue,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: context.responsive(5),
                                  ),
                                  
                                  TextFormField(
                                    controller: _firstNameController,
                                    style: TextStyle(
                                      color: context.skyBlue,
                                      fontSize: 12,
                                    ),
                                    minLines: 1,
                                    maxLines: 1, // Ensures the field stays single-line
                                    decoration: getFormDecoration(
                                      hintText: 'Enter your first name',
                                      errorText: _firstNameError,
                                    ),
                                    onChanged: (value) {
                                     if (_firstNameError != null) {
                                        setState(() {
                                          _firstNameError = null;
                                        });
                                      }
                                     },
                                  ),
                                ],
                              ),
                            ),
                    
                            SizedBox(
                              width: context.responsive(10),
                            ),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: context.skyBlue,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: context.responsive(5),
                                  ),
                                  
                                  TextFormField(
                                    controller: _lastNameController,
                                    style: TextStyle(
                                      color: context.skyBlue,
                                      fontSize: 12,
                                    ),
                                    minLines: 1,
                                    maxLines: 1, // Ensures the field stays single-line
                                    decoration: getFormDecoration(
                                      hintText: 'Enter your last name',
                                      errorText: _lastNameError,
                                    ),
                                    onChanged: (value) {
                                      if (_lastNameError != null) {
                                        setState(() {
                                          _lastNameError = null;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(3),
                        ),
                    
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                    
                        SizedBox(
                          height: context.responsive(5),
                        ),
                    
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                          ),
                          minLines: 1,
                          maxLines: 1, // Ensures the field stays single-line
                          decoration: getFormDecoration(
                            hintText: 'Enter your email',
                            errorText: _emailError,
                          ),
                          onChanged: (value) {
                            if (_emailError != null) {
                              setState(() {
                                _emailError = null;
                              });
                            }
                          },
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(3),
                        ),
                    
                        Text(
                          'LRN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                    
                        SizedBox(
                          height: context.responsive(5),
                        ),
                    
                        TextFormField(
                          controller: _lrnController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12), 
                          ],
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                          ),
                          minLines: 1,
                          maxLines: 1, 
                          decoration: getFormDecoration(
                            hintText: 'Enter your LRN',
                            errorText: _lrnError,
                          ),
          
                          onChanged: (value) {
                            if (_lrnError != null) {
                              setState(() {
                                _lrnError = null;
                              });
                            }
                          },
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(3),
                        ),
                    
                        Text(
                          'Strand',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                         
                        SizedBox(
                          height: context.responsive(5),
                        ),
                    
                        DropdownButtonFormField<String>(
                          decoration: getDropdownDecoration(errorText: _strandError),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: context.primaryColor,
                            size: 22, // Make icon more appropriately sized
                          ),
                          dropdownColor: context.whiteColor,
                          isExpanded: true,
                          hint: Text(
                            'Select Strand',
                            style: TextStyle(
                              color: context.skyBlue.withAlpha(128),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: _selectedStrand,
                          items: [
                            'STEM',
                            'ABM',
                            'HUMSS'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: context.skyBlue,
                                  fontSize: 12,
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
                    
                        SizedBox(
                          height: context.heightPercent(3),
                        ),
                    
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                                          
                        SizedBox(
                          height: context.responsive(5),
                        ),
                                          
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(
                                  'Male',
                                  style: TextStyle(
                                    color: context.skyBlue,
                                    fontSize: 12,
                                  ),
                                ),
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                                activeColor: context.skyBlue,
                                fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return context.secondaryColor;
                                    }
                                    return context.skyBlue;
                                  }
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
                                    fontSize: 12,
                                  ),
                                ),
                                value: 'Female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                                activeColor: context.whiteColor,
                                fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return context.secondaryColor;
                                    }
                                    return context.skyBlue;
                                  }
                                ),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              )
                            ),
                          ],
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(2),
                        ),
                    
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                    
                        SizedBox(
                          height: context.responsive(5),
                        ),
                    
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                          ),
                          minLines: 1,
                          maxLines: 1, // Ensures the field stays single-line
                          decoration: getFormDecoration(
                            hintText: 'Enter your password',
                            errorText: _passwordError,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: context.responsive(10),
                                ),
                                child: Icon(
                                  _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                  color: context.skyBlue,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (_passwordError != null) {
                              setState(() {
                                _passwordError = null;
                              });
                            }
                          },
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(3),
                        ),
                    
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue,
                          ),
                        ),
                    
                        SizedBox(
                          height: context.responsive(5),
                        ),
                    
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(
                            color: context.skyBlue,
                            fontSize: 12,
                          ),
                          minLines: 1,
                          maxLines: 1, // Ensures the field stays single-line
                          decoration: getFormDecoration(
                            hintText: 'Confirm your password',
                            errorText: _confirmPasswordError,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: context.responsive(10),
                                ),
                                child: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                  color: context.skyBlue,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (_confirmPasswordError != null) {
                              setState(() {
                                _confirmPasswordError = null;
                              });
                            }
                          },
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(5),
                        ),
                    
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: context.widthPercent(30),
                            height: context.heightPercent(5),
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool isValid = true;
          
                                  if(_firstNameController.text.isEmpty) {
                                    setState(() {
                                      _firstNameError = 'First name is required';
                                    });
                                    isValid = false;
                                  } else if (RegExp(r'^[a-z]').hasMatch(_firstNameController.text)) {
                                    setState(() {
                                      _firstNameError = 'First letter should be capitalized';
                                    });
                                    isValid = false;
                                  } else if (RegExp(r'^[0-9]').hasMatch(_firstNameController.text)) {
                                    setState(() {
                                      _firstNameError = 'First name cannot start with a number';
                                    });
                                  } else if (!RegExp(r'^[A-Za-z]+$').hasMatch(_firstNameController.text)) {
                                    setState(() {
                                      _firstNameError = 'No special characters';
                                    });
                                    isValid = false;
                                  } else if (_firstNameController.text.length < 2) {
                                    setState(() {
                                      _firstNameError = 'Atleast 2 letters required';
                                    });
                                    isValid = false;
                                  }  
                                  
                                  if(_lastNameController.text.isEmpty) {
                                    setState(() {
                                      _lastNameError = 'Last name is required';
                                    });
                                    isValid = false;
                                  } else if (RegExp(r'^[0-9]').hasMatch(_lastNameController.text)) {
                                    setState(() {
                                      _lastNameError = 'Cannot start with a number';
                                    });
                                    isValid = false;
                                  } else if (RegExp(r'^[a-z]').hasMatch(_lastNameController.text)) {
                                    setState(() {
                                      _lastNameError = 'First letter should be capitalized';
                                    });
                                    isValid = false;
                                  } else if (!RegExp(r'^[A-Za-z]+$').hasMatch(_lastNameController.text)) {
                                    setState(() {
                                      _lastNameError = 'No special characters';
                                    });
                                    isValid = false;
                                  } else if (_lastNameController.text.length < 2) {
                                    setState(() {
                                      _lastNameError = 'Atleast 2 letters required';
                                    });
                                    isValid = false;
                                  } 
          
                                  if (_emailController.text.isEmpty) {
                                    setState(() {
                                      _emailError = 'Email is required';
                                    });
                                    isValid = false;
                                  } else {
                                    String username = _emailController.text.split('@')[0];
                                    
                                    if (username.isEmpty) {
                                      setState(() {
                                        _emailError = 'Email username cannot be empty';
                                      });
                                      isValid = false;
                                    } else if (RegExp(r'^[0-9]').hasMatch(username)) {
                                      setState(() {
                                        _emailError = 'Email cannot start with a number';
                                      });
                                      isValid = false;
                                    } else if (RegExp(r'^[A-Z]').hasMatch(username)) {
                                      setState(() {
                                        _emailError = 'Email cannot start with a capital letter';
                                      });
                                      isValid = false;
                                    } else if (RegExp(r'[^a-z0-9]').hasMatch(username)) {
                                      setState(() {
                                        _emailError = 'Email can only contain lowercase letters and numbers';
                                      });
                                      isValid = false;
                                    } else if (!_emailController.text.endsWith('@gmail.com')) {
                                      setState(() {
                                        _emailError = 'Only Gmail accounts are allowed';
                                      });
                                      isValid = false;
                                    }
                                  }
          
                                  if(_lrnController.text.isEmpty) {
                                    setState(() {
                                      _lrnError = 'LRN is required';
                                    });
                                    isValid = false;
                                  } else if (_lrnController.text.length != 12 || !RegExp(r'^\d{12}$').hasMatch(_lrnController.text)) {
                                    setState(() {
                                      _lrnError = 'LRN must be 12 digits';
                                    });
                                    isValid = false;
                                  }
          
                                  if(_selectedStrand == null) {
                                    setState(() {
                                      _strandError = 'Strand is required';
                                      isValid = false;
                                    });
                                  }
          
          
                                  if (_passwordController.text.isEmpty) {
                                    setState(() {
                                      _passwordError = 'Password is required';
                                      isValid = false;
                                    });
                                  } else if (_passwordController.text.length < 6) {
                                    setState(() {
                                      _passwordError = 'Password must be at least 6 characters';
                                      isValid = false;
                                    });
                                  }
                                  
                                  if (_confirmPasswordController.text.isEmpty) {
                                    setState(() {
                                      _confirmPasswordError = 'Confirm password is required';
                                      isValid = false;
                                    });
                                  } else if (_confirmPasswordController.text != _passwordController.text) {
                                    setState(() {
                                      _confirmPasswordError = 'Passwords do not match';
                                      isValid = false;
                                    });
                                  }
                                  
                                  if (isValid) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    
                                    try {
                                      // Create user with Firebase Auth
                                      print("Creating Firebase Auth user...");
                                      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                      print("User created successfully: ${userCredential.user?.uid}");
                                      
                                      // Add user profile data to Firestore
                                      print("Adding user to Firestore...");
                                      try {
                                        // Add a timeout to your Firestore operation
                                        await Future.any([
                                          FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                                            'firstName': _firstNameController.text.trim(),
                                            'lastName': _lastNameController.text.trim(),
                                            'email': _emailController.text.trim(),
                                            'lrn': _lrnController.text,
                                            'strand': _selectedStrand,
                                            'gender': _selectedGender,
                                            'createdAt': FieldValue.serverTimestamp(),
                                          }, SetOptions(merge: false)),
                                          Future.delayed(Duration(seconds: 10)).then((_) => throw TimeoutException('Firestore operation timed out')),
                                        ]);
                                      } catch (e) {
                                        if (e is TimeoutException) {
                                          print("Firestore operation timed out, but user was created");
                                          // Continue with your success flow
                                        } else {
                                          rethrow;
                                        }
                                      }
                                      print("User added to Firestore successfully");
                                      
                                      // Set user display name (visible throughout app)
                                      print("Updating display name...");
                                      await userCredential.user!.updateDisplayName("${_firstNameController.text} ${_lastNameController.text}");
                                      print("Display name updated successfully");
                                      
                                      // After setting user data and updating display name
                                      await FirebaseAuth.instance.signOut();
                                      
                                      await FirebaseFirestore.instance.terminate();
                                      await FirebaseFirestore.instance.clearPersistence();
                                      
                                      setState(() {
                                        _isLoading = false;
                                      });
          
                                      _showSuccessDialog(context);
                                    } on FirebaseAuthException catch (e) {
                                      print("Firebase Auth Error: ${e.code} - ${e.message}");
                                      // Handle Firebase authentication errors
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      
                                      String errorMessage = "An error occurred during sign up";
                                      
                                      if (e.code == 'weak-password') {
                                        errorMessage = 'The password provided is too weak';
                                        setState(() { _passwordError = errorMessage; });
                                      } else if (e.code == 'email-already-in-use') {
                                        errorMessage = 'An account already exists for that email';
                                        setState(() { _emailError = errorMessage; });
                                      } else if (e.code == 'invalid-email') {
                                        errorMessage = 'Invalid email address format';
                                        setState(() { _emailError = errorMessage; });
                                      }
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(errorMessage))
                                      );
                                    } catch (e) {
                                      // Handle other errors
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: ${e.toString()}')),
                                      );
                                    }
                                  }
          
                                },
          
                                
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading ? context.primaryColor : context.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(context.responsive(3),
                                  )
                                )
                              )
                              ),
                              child: Text(
                                _isLoading ? 'Creating Account' : 'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.whiteColor,
                                  fontSize: context.responsive(5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(5),
                        ),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: context.skyBlue,
                                fontSize: context.responsive(5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            
                            GestureDetector(
                              onTap: () {
                                // Sign out the user in case they were automatically signed in
                                FirebaseAuth.instance.signOut();
                                
                                Navigator.pushReplacement(
                                  context, 
                                  SlideLeftRight2(enterPage: const SignIn(),
                                    exitPage: const SignUp())
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: context.primaryColor,
                                  fontSize: context.responsive(5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(
                          height: context.heightPercent(5),
                        ),
                    
                      ],
                    ),
                  ),
                )
              ),
            ),
          ),

          if (_isLoading)
           Container(
            width: context.widthPercent(100),
            height: context.heightPercent(100),
            color: Colors.black.withOpacity(0.5),
             child: BouncingDotsLoading(
              color: context.whiteColor,
              backgroundColor: Colors.transparent,
              size: context.heightPercent(5),
              dotSize: 6.0,
             ),
           )
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              (7),
            )
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding:  EdgeInsets.all(context.responsive(10)),
            decoration: BoxDecoration(
              color: context.whiteColor,
              borderRadius: BorderRadius.circular(context.responsive(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: context.responsive(16),
                  height: context.responsive(16),
                  child: Image.asset(
                    'assets/icons/success_icon.png',
                    fit: BoxFit.contain,
                    color: context.primaryColor,
                  ),
                ),
                
                SizedBox(height: context.heightPercent(0.5)),

                Text(
                  'Success!',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: context.heightPercent(1)),

                Text(
                  'Now log in to start your learning adventure.',
                  style: TextStyle(
                    color: context.skyBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: context.heightPercent(3)),

                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      SlideLeftRight2(enterPage: const SignIn(),
                        exitPage: const SignUp())
                    );
                  },
                  child: Container(
                    width: context.widthPercent(25),
                    height: context.heightPercent(5),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.circular(context.responsive(3)),
                      
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        );
      }
    );
  }
}