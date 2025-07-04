import 'package:flutter/material.dart';
import 'package:physica_app/screens/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Current user name state
  String firstName = "John";
  String lastName = "Doe";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // User is signed in
      String uid = user.uid;
      String? email = user.email;
      String? displayName = user.displayName;
      String? photoURL = user.photoURL;
      
      print('User ID: $uid');
      print('Email: $email');
      print('Display Name: $displayName');
      
      // You can also access additional user information from Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          Map<String, dynamic> userData = doc.data()!;
          setState(() {
            firstName = userData['firstName'] ?? '';
            lastName = userData['lastName'] ?? '';
          });
          print('First Name: ${userData['firstName']}');
          print('Last Name: ${userData['lastName']}');
          // Access other fields as needed
        }
      });
    } else {
      // No user is signed in
      print('No user is currently logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: SafeArea(
        child: Container(
          width: context.widthPercent(100),
          height: MediaQuery.of(context).size.height,
          color: context.whiteColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                left: context.responsive(5) + context.widthPercent(5),
                  right: context.responsive(5) + context.widthPercent(5),
                  // Add bottom padding
              ),
              child: Column(
                children: [
                  // Profile header section
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: context.heightPercent(3)),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: context.responsive(10),
                            fontWeight: FontWeight.w600,
                            color: context.skyBlue,
                          ),
                        ),
                        SizedBox(height: context.heightPercent(5)),
            
                        // Profile picture with edit button
                        Stack(
                          children: [
                            // Profile picture
                            Container(
                              width: context.responsive(64),
                              height: context.responsive(64),
                              decoration: BoxDecoration(
                                color: context.skyBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.skyBlue,
                                  width: context.responsive(2),
                                ),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/profile_picture.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
            
                            // Edit icon button
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Add functionality to change profile picture
                                  print('Change profile picture');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(context.responsive(3)),
                                  decoration: BoxDecoration(
                                    color: context.whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.skyBlue,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/camera_icon.png',
                                    width: context.responsive(10),
                                    height: context.responsive(10),
                                    color: context.skyBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            
                        SizedBox(height: context.heightPercent(2)),
            
                        // User name
                        Text(
                          '$firstName $lastName',
                          style: TextStyle(
                            fontSize: context.responsive(8),
                            fontWeight: FontWeight.w600,
                            color: context.skyBlue,
                          ),
                        ),
            
                        // User email
                        Text(
                          'johndoe@gmail.com',
                          style: TextStyle(
                            fontSize: context.responsive(5),
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue.withOpacity(0.7),
                          ),
                        ),
            
                        SizedBox(height: context.heightPercent(6)),
                      ],
                    ),
                  ),
            
                  // Profile options
                  Column(
                    children: [
                      // Change name option
                      _buildProfileOption(
                        context: context,
                        title: 'Change Name',
                        iconPath: 'assets/icons/edit_icon.png',
                        onTap: () {
                          _showChangeNameDialog(context);
                        },
                      ),
                  
                      _buildDivider(context),
                  
                      // Change password option
                      _buildProfileOption(
                        context: context,
                        title: 'Change Password',
                        iconPath: 'assets/icons/key_icon.png',
                        onTap: () {
                          _showChangePasswordEmailDialog(context);
                        },
                      ),
                  
                      _buildDivider(context),
                  
                      // Sign out option
                      _buildProfileOption(
                        context: context,
                        title: 'Sign Out',
                        iconPath: 'assets/icons/sign_out_icon.png',
                        onTap: () {
                          _showSignOutConfirmationDialog(context);
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
            
                  SizedBox(height: context.heightPercent(5)),
            
                  // App version
                  Text(
                    'Physica v1.0.0',
                    style: TextStyle(
                      fontSize: context.responsive(4),
                      color: context.skyBlue.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required String title,
    required String iconPath,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPercent(5),
          vertical: context.heightPercent(2),
        ),
        child: Row(
          children: [
            // Option icon
            Image.asset(
              iconPath,
              width: context.responsive(10),
              height: context.responsive(10),
              color: isDestructive ? context.redColor : context.skyBlue,
            ),

            SizedBox(width: context.widthPercent(5)),

            // Option text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: context.responsive(7),
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? context.redColor : context.skyBlue,
                ),
              ),
            ),

            // Forward icon
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: context.responsive(10),
              color: isDestructive
                  ? context.redColor
                  : context.skyBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: context.skyBlue.withOpacity(0.5),
      thickness: 1.5,
      height: 1,
      indent: context.widthPercent(5),
      endIndent: context.widthPercent(5),
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    // Controllers for text fields
    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.responsive(5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Change Name',
                    style: TextStyle(
                      fontSize: context.responsive(8),
                      fontWeight: FontWeight.w600,
                      color: context.skyBlue,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // First Name field
                Text(
                  'First Name',
                  style: TextStyle(
                    fontSize: context.responsive(5),
                    fontWeight: FontWeight.w500,
                    color: context.skyBlue,
                  ),
                ),
                SizedBox(height: context.heightPercent(1)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.responsive(3)),
                  ),
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter first name',
                      hintStyle: TextStyle(
                        color: context.skyBlue.withOpacity(0.5),
                        fontSize: context.responsive(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(4),
                        vertical: context.heightPercent(1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                    ),
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.skyBlue,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(2)),
                
                // Last Name field
                Text(
                  'Last Name',
                  style: TextStyle(
                    fontSize: context.responsive(5),
                    fontWeight: FontWeight.w500,
                    color: context.skyBlue,
                  ),
                ),
                SizedBox(height: context.heightPercent(1)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.responsive(3)),
                  ),
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter last name',
                      hintStyle: TextStyle(
                        color: context.skyBlue.withOpacity(0.5),
                        fontSize: context.responsive(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(4),
                        vertical: context.heightPercent(1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                    ),
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.skyBlue,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Dialog buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.widthPercent(5)),
                    
                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        // Update the name
                        setState(() {
                          firstName = firstNameController.text.trim();
                          lastName = lastNameController.text.trim();
                        });
                        
                        // Close dialog
                        Navigator.of(context).pop();
                        
                        // Show confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Name updated successfully!'),
                            backgroundColor: context.redColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.responsive(3)),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.responsive(3)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPercent(4),
                          vertical: context.heightPercent(1),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          fontWeight: FontWeight.w500,
                          color: context.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 1: Email verification dialog
  void _showChangePasswordEmailDialog(BuildContext context) {
    final emailController = TextEditingController(text: 'johndoe@gmail.com');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.responsive(5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Verify Email',
                    style: TextStyle(
                      fontSize: context.responsive(8),
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Description text
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Please enter your email address to receive a verification code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.primaryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Email field
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: context.responsive(5),
                    fontWeight: FontWeight.w500,
                    color: context.skyBlue,
                  ),
                ),
                SizedBox(height: context.heightPercent(1)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.responsive(3)),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: context.skyBlue.withOpacity(0.5),
                        fontSize: context.responsive(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(4),
                        vertical: context.heightPercent(1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                        borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                      ),
                      filled: true,
                      fillColor: context.whiteColor,
                    ),
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.skyBlue,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Dialog buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.widthPercent(5)),
                    
                    // Confirm button
                    ElevatedButton(
                      onPressed: () {
                        // Close current dialog
                        Navigator.of(context).pop();
                        // Show OTP verification dialog
                        _showOtpVerificationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.responsive(3)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPercent(4),
                          vertical: context.heightPercent(1),
                        ),
                      ),
                      child: Text(
                        'Send Code',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          fontWeight: FontWeight.w500,
                          color: context.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 2: OTP verification dialog
  void _showOtpVerificationDialog(BuildContext context) {
    // Controllers for the 6 OTP digits
    final List<TextEditingController> otpControllers = List.generate(
      6, (_) => TextEditingController()
    );
    final List<FocusNode> focusNodes = List.generate(
      6, (_) => FocusNode()
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.responsive(5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dialog title
                Text(
                  'Enter Verification Code',
                  style: TextStyle(
                    fontSize: context.responsive(8),
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor,
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Description text
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'We have sent a verification code to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.primaryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => Container(
                      width: context.responsive(14),
                      height: context.responsive(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                      ),
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          // Auto-focus to next field
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                          ),
                          filled: true,
                          fillColor: context.whiteColor,
                        ),
                        style: TextStyle(
                          fontSize: context.responsive(7),
                          fontWeight: FontWeight.bold,
                          color: context.skyBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(2)),
                
                // Resend code option
                GestureDetector(
                  onTap: () {
                    // Add resend code logic here
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Dialog buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.widthPercent(5)),
                    
                    // Verify button
                    ElevatedButton(
                      onPressed: () {
                        // Close current dialog
                        Navigator.of(context).pop();
                        // Show new password dialog
                        _showNewPasswordDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.responsive(3)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPercent(4),
                          vertical: context.heightPercent(1),
                        ),
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          fontWeight: FontWeight.w500,
                          color: context.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 3: New password dialog
  void _showNewPasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.responsive(5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.responsive(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dialog title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: context.responsive(8),
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: context.heightPercent(3)),
                    
                    // New Password field
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: context.responsive(5),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    ),
                    SizedBox(height: context.heightPercent(1)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                      ),
                      child: TextField(
                        controller: newPasswordController,
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(
                            color: context.skyBlue.withOpacity(0.5),
                            fontSize: context.responsive(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.widthPercent(4),
                            vertical: context.heightPercent(1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                          ),
                          filled: true,
                          fillColor: context.whiteColor,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                              color: context.skyBlue,
                              size: context.responsive(7),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.skyBlue,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: context.heightPercent(2)),
                    
                    // Confirm Password field
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: context.responsive(5),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    ),
                    SizedBox(height: context.heightPercent(1)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.responsive(3)),
                      ),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                          hintStyle: TextStyle(
                            color: context.skyBlue.withOpacity(0.5),
                            fontSize: context.responsive(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.widthPercent(4),
                            vertical: context.heightPercent(1.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.responsive(3)),
                            borderSide: BorderSide(color: context.skyBlue, width: 2.0),
                          ),
                          filled: true,
                          fillColor: context.whiteColor,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              color: context.skyBlue,
                              size: context.responsive(7),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.skyBlue,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: context.heightPercent(3)),
                    
                    // Dialog buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Cancel button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: context.responsive(5),
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        
                        SizedBox(width: context.widthPercent(5)),
                        
                        // Save button
                        ElevatedButton(
                          onPressed: () {
                            // Validate passwords match
                            if (newPasswordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Passwords do not match'),
                                  backgroundColor: context.redColor,
                                ),
                              );
                              return;
                            }
                            
                            // Close dialog
                            Navigator.of(context).pop();
                            
                            // Show confirmation message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Password updated successfully!'),
                                backgroundColor: context.primaryColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.responsive(3)),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.responsive(3)),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthPercent(4),
                              vertical: context.heightPercent(1),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: context.responsive(5),
                              fontWeight: FontWeight.w500,
                              color: context.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.responsive(5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsive(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: context.responsive(8),
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Confirmation message
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Are you sure you want to sign out?',
                    style: TextStyle(
                      fontSize: context.responsive(5),
                      color: context.primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                
                SizedBox(height: context.heightPercent(3)),
                
                // Dialog buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.widthPercent(5)),
                    
                    // Confirm button
                    ElevatedButton(
                      onPressed: () {
                        // Close the confirmation dialog
                        Navigator.of(context).pop();
                        
                        // Directly navigate to sign in screen without loading state
                        Navigator.of(context).pushReplacement(
                          SlideRightLeft2(enterPage: SignIn(), exitPage: ProfileScreen())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.responsive(3)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPercent(4),
                          vertical: context.heightPercent(1),
                        ),
                      ),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: context.responsive(5),
                          fontWeight: FontWeight.w500,
                          color: context.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this function to your profile screen or wherever you want to add logout functionality
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      
      // Navigate back to sign in screen after successful logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }
}