import 'package:flutter/material.dart';
import 'package:physica_app/screens/auth/sign_in.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/loading_state.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physica_app/firebase/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Current user name state
  String firstName = "";
  String lastName = "";
  String userEmail = "loading...";

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
      String email = user.email ?? 'No email';
      
      // Update email in the UI immediately
      setState(() {
        userEmail = email;
      });
      
      // Access student_accounts collection
      FirebaseFirestore.instance
          .collection('student_accounts')
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          Map<String, dynamic> userData = doc.data()!;
          setState(() {
            firstName = userData['firstName'] ?? '';
            lastName = userData['lastName'] ?? '';
          });
        } else {
          setState(() {
            firstName = '';
            lastName = '';
          });
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    } else {
      // Schedule navigation after the current build phase completes
      Future.microtask(() {
        if (mounted) { // Check if the widget is still in the tree
          Navigator.of(context).pushReplacement(
            SlideRightLeft2(enterPage: const SignIn(), exitPage: widget)
          );
        }
      });
    }
  }

  // Reusable text field widget with consistent media query
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    bool showToggleIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: context.fontSize(12, xs: 6, sm: 8, md: 10, lg: 12),
            fontWeight: FontWeight.w500,
            color: context.skyBlue,
          ),
        ),
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: context.skyBlue.withOpacity(0.5),
                fontSize: context.fontSize(12, xs: 6, sm: 8, md: 10, lg: 12),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.space(16, xs: 12, sm: 14, md: 16, lg: 18),
                vertical: context.space(12, xs: 10, sm: 11, md: 12, lg: 14),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
                borderSide: BorderSide(
                  color: context.skyBlue, 
                  width: context.responsiveCombined(1.0, xs: 0.8, sm: 0.9, md: 1.0, lg: 1.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(context.radius(5, xs: 3, sm: 4, md: 8, lg: 10, xl: 11)),
               ),
                borderSide: BorderSide(
                  color: context.skyBlue, 
                  width: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 1.8, xl: 2.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(context.radius(8, xs: 5, sm: 6, md: 10, lg: 12, xl: 14)),
                ),
                borderSide: BorderSide(
                  color: context.skyBlue, 
                  width: context.responsiveCombined(2, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
                ),
              ),
              filled: true,
              fillColor: context.whiteColor,
              suffixIcon: showToggleIcon ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: context.skyBlue,
                  size: context.iconSize(20, xs: 16, sm: 18, md: 20, lg: 22),
                ),
                onPressed: onToggleVisibility,
              ) : null,
            ),
            style: TextStyle(
              fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14),
              color: context.skyBlue,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: SafeArea(
        child: Container(
          width: context.widthPercent(100),
          height: context.heightPercent(100),
          color: context.whiteColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                bottom: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                left: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
                right: context.space(20, xs: 15, sm: 18, md: 30, lg: 30),
              ),
              child: Column(
                children: [
                  // Profile header section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: context.fontSize(16, xs: 12, sm: 14, md: 16, lg: 18, xl: 20),
                            fontWeight: FontWeight.w600,
                            color: context.skyBlue,
                          ),
                        ),
                        
                        SizedBox(height: context.space(30, xs: 25, sm: 28, md: 35, lg: 40)),
            
                        // Profile picture with edit button
                        Stack(
                          children: [
                            // Profile picture
                            Container(
                              width: context.iconSize(64, xs: 80, sm: 100, md: 120, lg: 130, xl: 140),
                              height: context.iconSize(64, xs: 80, sm: 100, md: 120, lg: 130, xl: 140),
                              decoration: BoxDecoration(
                                color: context.skyBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.skyBlue,
                                  width: context.responsiveCombined(2, xs: 1.5, sm: 2.0, md: 3.0, lg: 3.5, xl: 4.0),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/profile_picture.jpg'),
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
                                  padding: EdgeInsets.all(context.space(3, xs: 2, sm: 4, md: 6, lg: 8)),
                                  decoration: BoxDecoration(
                                    color: context.whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.skyBlue,
                                      width: context.responsiveCombined(2.5, xs: 1.0, sm: 1.5, md: 2.0, lg: 3.0),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/camera_icon.png',
                                    width: context.iconSize(10, xs: 16, sm: 18, md: 20, lg: 24, xl: 28),
                                    height: context.iconSize(10, xs: 8, sm: 9, md: 20, lg: 24, xl: 28),
                                    color: context.skyBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            
                        SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),
            
                        // User name
                        Text(
                          '$firstName $lastName',
                          style: TextStyle(
                            fontSize: context.fontSize(16, xs: 14, sm: 16, md: 18, lg: 20, xl: 22),
                            fontWeight: FontWeight.w600,
                            color: context.skyBlue,
                          ),
                        ),
            
                        SizedBox(height: context.space(4, xs: 3, sm: 3.5, md: 4, lg: 6)),
            
                        // User email
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14, xl: 16),
                            fontWeight: FontWeight.w500,
                            color: context.skyBlue.withOpacity(0.7),
                          ),
                        ),
            
                        SizedBox(height: context.space(40, xs: 30, sm: 35, md: 40, lg: 50)),
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
                          _showChangePasswordDialog(context);
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
            
                  SizedBox(height: context.space(40, xs: 30, sm: 35, md: 40, lg: 50)),
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
          horizontal: context.space(20, xs: 15, sm: 18, md: 25, lg: 30),
          vertical: context.space(16, xs: 12, sm: 14, md: 16, lg: 20),
        ),
        child: Row(
          children: [
            // Option icon
            Image.asset(
              iconPath,
              width: context.iconSize(20, xs: 16, sm: 18, md: 20, lg: 24, xl: 28),
              height: context.iconSize(20, xs: 16, sm: 18, md: 20, lg: 24, xl: 28),
              color: isDestructive ? context.redColor : context.skyBlue,
            ),

            SizedBox(width: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),

            // Option text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: context.fontSize(14, xs: 12, sm: 13, md: 14, lg: 16, xl: 18),
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? context.redColor : context.skyBlue,
                ),
              ),
            ),

            // Forward icon
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: context.iconSize(16, xs: 14, sm: 15, md: 16, lg: 18, xl: 20),
              color: isDestructive ? context.redColor : context.skyBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: context.skyBlue.withOpacity(0.5),
      thickness: context.responsiveCombined(1.5, xs: 1.0, sm: 1.2, md: 1.5, lg: 2.0),
      height: 1,
      indent: context.space(20, xs: 15, sm: 18, md: 25, lg: 30),
      endIndent: context.space(20, xs: 15, sm: 18, md: 25, lg: 30),
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
            borderRadius: BorderRadius.circular(context.radius(8, xs: 6, sm: 7, md: 8, lg: 10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.space(24, xs: 16, sm: 20, md: 24, lg: 28)),
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
                      fontSize: context.fontSize(18, xs: 16, sm: 17, md: 18, lg: 20, xl: 22),
                      fontWeight: FontWeight.w600,
                      color: context.skyBlue,
                    ),
                  ),
                ),
                
                SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                
                // First Name field - using reusable widget
                _buildTextField(
                  controller: firstNameController,
                  hintText: 'Enter first name',
                  labelText: 'First Name',
                ),
                
                SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),
                
                // Last Name field - using reusable widget
                _buildTextField(
                  controller: lastNameController,
                  hintText: 'Enter last name',
                  labelText: 'Last Name',
                ),
                
                SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                
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
                          fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.space(20, xs: 15, sm: 18, md: 20, lg: 24)),
                    
                    // Save button
                    ElevatedButton(
                      onPressed: () async {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext loadingContext) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: BouncingDotsLoading(
                                color: context.whiteColor,
                                size: context.heightPercent(5),
                                dotSize: context.iconSize(6, xs: 4, sm: 5, md: 6, lg: 8),
                              ),
                            );
                          },
                        );
                        
                        try {
                          // Get current user
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            // Update in Firestore
                            await FirebaseFirestore.instance
                                .collection('student_accounts')
                                .doc(user.uid)
                                .update({
                                  'firstName': firstNameController.text.trim(),
                                  'lastName': lastNameController.text.trim(),
                                });
                                
                            // Update local state
                            setState(() {
                              firstName = firstNameController.text.trim();
                              lastName = lastNameController.text.trim();
                            });
                            
                            // Close loading dialog and name dialog
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Close loading
                              Navigator.of(context).pop(); // Close name dialog
                              
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Name updated successfully!'),
                                  backgroundColor: context.primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(context.space(16)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(context.radius(8)),
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // Close loading dialog
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error updating name: $e'),
                                backgroundColor: context.redColor,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(context.space(16)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.radius(8)),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.space(16, xs: 12, sm: 14, md: 16, lg: 20),
                          vertical: context.space(8, xs: 6, sm: 7, md: 8, lg: 10),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14),
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

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius(8, xs: 6, sm: 7, md: 8, lg: 10)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(context.space(24, xs: 16, sm: 20, md: 24, lg: 28)),
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
                            fontSize: context.fontSize(18, xs: 14, sm: 15, md: 16, lg: 17, xl: 18),
                            fontWeight: FontWeight.w600,
                            color: context.skyBlue,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                      
                      // Current Password field - using reusable widget
                      _buildTextField(
                        controller: currentPasswordController,
                        hintText: 'Enter current password',
                        labelText: 'Current Password',
                        obscureText: _obscureCurrentPassword,
                        showToggleIcon: true,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      
                      SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),
                      
                      // New Password field - using reusable widget
                      _buildTextField(
                        controller: newPasswordController,
                        hintText: 'Enter new password',
                        labelText: 'New Password',
                        obscureText: _obscureNewPassword,
                        showToggleIcon: true,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      
                      SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),
                      
                      // Confirm Password field - using reusable widget
                      _buildTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm new password',
                        labelText: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        showToggleIcon: true,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      
                      SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                      
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
                                fontSize: context.fontSize(12, xs: 6, sm: 8, md: 10, lg: 12),
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                          
                          SizedBox(width: context.space(20, xs: 15, sm: 18, md: 20, lg: 24)),
                          
                          // Save button with responsive styling
                          ElevatedButton(
                            onPressed: () async {
                              // Validate passwords
                              if (currentPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter your current password',
                                    style: TextStyle(
                                      fontSize: context.fontSize(12, xs: 6, sm: 8, md: 10, lg: 12),
                                      fontWeight: FontWeight.w500
                                    )
                                    ),
                                    backgroundColor: context.redColor,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(context.space(16)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(context.radius(8)),
                                    ),
                                  ),
                                );
                                return;
                              }
                              
                              if (newPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter a new password'),
                                    backgroundColor: context.redColor,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(context.space(16)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(context.radius(8)),
                                    ),
                                  ),
                                );
                                return;
                              }
                              
                              if (newPasswordController.text != confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('New passwords do not match'),
                                    backgroundColor: context.redColor,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(context.space(16)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(context.radius(8)),
                                    ),
                                  ),
                                );
                                return;
                              }
                              
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext loadingContext) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: BouncingDotsLoading(
                                      color: context.whiteColor,
                                      size: context.heightPercent(5),
                                      dotSize: context.iconSize(6, xs: 4, sm: 5, md: 6, lg: 8),
                                    ),
                                  );
                                },
                              );
                              
                              try {
                                // Get current user
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  // Get user email
                                  String email = user.email ?? '';
                                  
                                  if (email.isEmpty) {
                                    throw FirebaseAuthException(
                                      code: 'no-email',
                                      message: 'User email not found',
                                    );
                                  }
                                  
                                  // Create credential with current password
                                  AuthCredential credential = EmailAuthProvider.credential(
                                    email: email,
                                    password: currentPasswordController.text,
                                  );
                                  
                                  // Re-authenticate user
                                  await user.reauthenticateWithCredential(credential);
                                  
                                  // Update password
                                  await user.updatePassword(newPasswordController.text);
                                  
                                  // Close loading dialog and password dialog
                                  if (context.mounted) {
                                    Navigator.of(context).pop(); // Close loading
                                    Navigator.of(context).pop(); // Close password dialog
                                    
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Password updated successfully!'),
                                        backgroundColor: context.primaryColor,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(context.space(16)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(context.radius(8)),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                // Close loading dialog
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  
                                  // Show specific error message
                                  String errorMessage;
                                  switch (e.code) {
                                    case 'wrong-password':
                                      errorMessage = 'Current password is incorrect';
                                      break;
                                    case 'weak-password':
                                      errorMessage = 'New password is too weak. Please use a stronger password';
                                      break;
                                    default:
                                      errorMessage = 'Error updating password: ${e.message}';
                                  }
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: context.redColor,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(context.space(16)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(context.radius(8)),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Close loading dialog
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  
                                  // Show generic error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error updating password: $e'),
                                      backgroundColor: context.redColor,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(context.space(16)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(context.radius(8)),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: context.space(16, xs: 12, sm: 14, md: 16, lg: 20),
                                vertical: context.space(8, xs: 6, sm: 7, md: 8, lg: 10),
                              ),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: context.fontSize(12, xs: 6, sm: 8, md: 10, lg: 12),
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
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius(8, xs: 8, sm: 10, md: 12, lg: 14)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.space(24, xs: 16, sm: 20, md: 24, lg: 28)),
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
                      fontSize: context.fontSize(18, xs: 16, sm: 17, md: 18, lg: 20, xl: 22),
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                
                // Confirmation message
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Are you sure you want to sign out?',
                    style: TextStyle(
                      fontSize: context.fontSize(14, xs: 12, sm: 13, md: 14, lg: 16),
                      color: context.primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                
                SizedBox(height: context.space(24, xs: 18, sm: 20, md: 24, lg: 28)),
                
                // Dialog buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14),
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(width: context.space(20, xs: 15, sm: 18, md: 20, lg: 24)),
                    
                    // Confirm button
                    SizedBox(
                      width: context.buttonWidth(80, xs: 80, sm: 90, md: 100, lg: 140, xl: 150, xxl: 180),
                      height: context.buttonHeight(40, xs: 32, sm: 36, md: 40, lg: 44, xl: 48, xxl: 52),
                      child: ElevatedButton(
                        onPressed: () {
                          // Close the confirmation dialog first
                          Navigator.of(dialogContext).pop();
                          
                          // Perform sign out with proper error handling
                          _performSignOut(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.radius(6, xs: 4, sm: 5, md: 6, lg: 8)),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: context.fontSize(12, xs: 10, sm: 11, md: 12, lg: 14),
                            fontWeight: FontWeight.w500,
                            color: context.whiteColor,
                          ),
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

  // New method that handles sign out logic and navigation separately
  Future<void> _performSignOut(BuildContext context) async {
    // Show custom loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext loadingContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BouncingDotsLoading(
            color: context.whiteColor,
            size: context.heightPercent(5),
            dotSize: context.iconSize(6, xs: 4, sm: 5, md: 6, lg: 8),
          ),
        );
      },
    );
    
    try {
      // Use AuthService instead of directly calling Firebase
      final authService = AuthService();
      await authService.signOut();
      
      // Dismiss loading dialog (carefully check if the context is still valid)
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Use a short delay before navigation to prevent animation glitches
        Future.delayed(const Duration(milliseconds: 700), () {
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false // Remove all previous routes
            );
          }
        });
      }
    } catch (e) {
      // Dismiss loading dialog if there's an error
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: context.redColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(context.space(16)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radius(8)),
            ),
          ),
        );
      }
    }
  }
}