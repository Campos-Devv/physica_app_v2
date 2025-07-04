import 'package:flutter/material.dart';
import 'package:physica_app/screens/home_screen.dart';
import 'package:physica_app/screens/sign_up.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  bool _obscurePassword = true;
  
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
  
  bool _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      return false;
    }
    
    if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return false;
    }
    
    setState(() {
      _passwordError = null;
    });
    return true;
  }
  
  Future<void> _signIn() async {
    final isEmailValid = _validateEmail(_emailController.text.trim());
    final isPasswordValid = _validatePassword(_passwordController.text);
    
    if (!isEmailValid || !isPasswordValid) {
      return;
    }
    
    setState(() {
      _isLoading = true; // Set loading to true at the start
    });
    
    try {
      print("Attempting login with: ${_emailController.text.trim()}");
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      print("Login successful: ${credential.user?.uid}");
      
      // Navigate to home screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        SlideRightLeft2(
          enterPage: HomeScreen(
            currentIndex: 0,
            onTap: (index) {},
          ), 
          exitPage: SignIn()
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      String errorMessage = 'Authentication failed';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Check your internet connection.';
      } else {
        errorMessage = 'Error: ${e.code} - ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Always set loading to false when done
      });
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
              color: context.whiteColor,
              width: context.widthPercent(100),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.responsive(5) + context.widthPercent(5),
                    right: context.responsive(5) + context.widthPercent(5),
                    top: context.responsive(15) + context.heightPercent(0),
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
                            color: context.skyBlue,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(
                        height: context.responsive(5),
                      ),
              
                      // Email field fix
                      TextField(
                        controller: _emailController,
                        style: TextStyle(
                          color: context.skyBlue,
                          fontSize: 12,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => _validateEmail(value),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 24,  // Increased vertical padding
                            horizontal: 14,
                          ),
                          filled: true,
                          fillColor: context.whiteColor,
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: context.skyBlue.withAlpha(128),
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                          ),
                          errorText: _emailError,
                          errorStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            height: 0.8,  // Reduce space taken by error text
                          ),
                          isDense: true,  // Makes the field more compact
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _emailError != null ? Colors.red : context.skyBlue,
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
                              color: _emailError != null ? Colors.red : context.skyBlue,
                              width: context.responsive(1.5)
                            )
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: context.responsive(1)
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(4))
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(6))
                            ),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: context.responsive(1.5)
                            )
                          ),
                        ),
                      ),
              
                      // Add extra space when error is present
                      SizedBox(
                        height: _emailError != null ? context.responsive(12) : context.responsive(8),
                      ),
              
                      Text(
                        'Password',
                        style: TextStyle(
                          color: context.skyBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: context.responsive(5),
                      ),
              
                      // Password field with same fixes
                      TextField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: context.skyBlue,
                          fontSize: 12,
                        ),
                        obscureText: _obscurePassword,
                        onChanged: (value) => _validatePassword(value),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 24,  // Increased vertical padding
                            horizontal: 18
                          ),
                          filled: true,
                          fillColor: context.whiteColor,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: context.skyBlue.withAlpha(128),
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                          ),
                          errorText: _passwordError,
                          errorStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            height: 0.8,  // Reduce space taken by error text
                          ),
                          isDense: true,  // Makes the field more compact
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: context.skyBlue,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _passwordError != null ? Colors.red : context.skyBlue,
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
                              color: _passwordError != null ? Colors.red : context.skyBlue,
                              width: context.responsive(1.5)
                            )
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: context.responsive(1)
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(4))
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(context.responsive(6))
                            ),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: context.responsive(1.5)
                            )
                          ),
                        ),
                      ),
              
                      // Add extra space when error is present
                      SizedBox(
                        height: _passwordError != null ? context.responsive(12) : context.responsive(7),
                      ),
              
                      GestureDetector(
                        onTap: () {
                          // Add forgot password functionality
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: context.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              
                      SizedBox(
                        height: context.responsive(20),
                      ),
              
                      // Login button without its own loading state
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: context.widthPercent(30),
                          height: context.heightPercent(5),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLoading ? context.skyBlue : context.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(context.responsive(3))
                                )
                              ),
                            ),
                            child: Text(
                              _isLoading ? 'Logging in...' : 'Login',
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
                              Navigator.pushReplacement(
                                context,
                                SlideRightLeft2(
                                  enterPage: HomeScreen(
                                    currentIndex: 0,
                                    onTap: (index) {},
                                  ), 
                                  exitPage: SignIn()
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.skyBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(context.responsive(3))
                                )
                              ),
                            ),
                            child: Text(
                              'Guest Mode',
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
          
          // Overlay loading state when _isLoading is true
          if (_isLoading)
            Container(
              width: context.widthPercent(100),
              height: context.heightPercent(100),
              color: Colors.black.withOpacity(0.5),
              child: BouncingDotsLoading(
                color: context.whiteColor,
                dotSize: 6, // Use responsive sizing
                size: context.heightPercent(5), // Use responsive sizing
              ),
            ),
        ],
      ),
    );
  }
}