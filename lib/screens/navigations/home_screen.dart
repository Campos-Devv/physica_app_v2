import 'package:flutter/material.dart';
import 'package:physica_app/screens/navigations/ar_samples.dart';
import 'package:physica_app/screens/lessons.dart'; // Add this import
import 'package:physica_app/screens/navigations/profile.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/logger.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/navigation.dart';
import 'package:physica_app/widgets/slide_right_left.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const HomeScreen({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Create content widgets rather than screens
  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeContent();
      case 1:
        return const ArSamplesScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeContent();
    }
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
          child: _getBody(),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Home content widget to avoid recursion
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isModularExpanded = false;
  String userName = 'User'; // Default name
  
  @override
  void initState() {
    super.initState();
    _getUserName();
  }
  
  Future<void> _getUserName() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      try {
        // First try to get data from Firestore as it contains more structured data
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('student_accounts') // Use the correct collection
            .doc(user.uid)
            .get();
        if (!mounted) return; // Check if widget is still mounted
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            // Directly use lastName field if available
            if (userData.containsKey('lastName') && userData['lastName'] != null) {
              userName = userData['lastName'];
            } else if (userData.containsKey('firstName') && userData['firstName'] != null) {
              // Fall back to firstName if lastName isn't available
              userName = userData['firstName'];
            } else {
              // Use displayName as last resort from Firestore
              userName = userData['displayName'] ?? 'User';
            }
          });
        } else {
          // If no Firestore data, fall back to Auth displayName
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            final nameParts = user.displayName!.split(' ');
            setState(() {
              // Get last part of name as last name if multiple parts exist
              userName = nameParts.length > 1 ? nameParts.last : user.displayName!;
            });
          }
        }
      } catch (e) {
        AppLogger.error('Error fetching user data', e);

        // If there's an error, try to use Auth displayName as fallback
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          final nameParts = user.displayName!.split(' ');
          setState(() {
            userName = nameParts.length > 1 ? nameParts.last : user.displayName!;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.space(20, xs: 15, sm: 25, md: 30, lg: 40, xl: 60),
        right: context.space(20, xs: 15, sm: 25, md: 30, lg: 40, xl: 60),
        top: context.space(15, xs: 12, sm: 25, md: 30, lg: 20, xl: 25),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting and profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: context.fontSize(16, xs: 16, sm: 20, md: 24, lg: 28, xl: 32),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    ),
                    SizedBox(width: context.space(6, xs: 4, sm: 5, md: 6, lg: 8)),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: context.fontSize(16, xs: 16, sm: 20, md: 24, lg: 28, xl: 32),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.skyBlue,
                      width: context.responsiveCombined(3.0, xs: 2.0, sm: 2.5, md: 3.0, lg: 3.5),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: context.iconSize(22, xs: 20, sm: 24, md: 28, lg: 32, xl: 36),
                    backgroundColor: context.skyBlue,
                    backgroundImage: const AssetImage(
                      'assets/images/profile_picture.jpg',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.space(16, xs: 14, sm: 16, md: 20, lg: 24)),

            // Assessment Points Card
            Container(
              width: context.widthPercent(100),
              height: context.breakpoint(
                xs: context.heightPercent(8),
                sm: context.heightPercent(9),
                md: context.heightPercent(10),
                lg: context.heightPercent(11),
                xl: context.heightPercent(12),
                fallback: context.heightPercent(12),
              ),
              decoration: BoxDecoration(
                color: context.skyBlue,
                borderRadius: BorderRadius.circular(
                  context.radius(8, xs: 8, sm: 10, md: 12, lg: 14, xl: 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.skyBlue.withAlpha(128),
                    spreadRadius: context.responsiveCombined(0.5, xs: 0.3, md: 0.5, lg: 0.8),
                    blurRadius: context.responsiveCombined(4, xs: 2, sm: 3, md: 4, lg: 6),
                    offset: Offset(0, context.responsiveCombined(2, xs: 1, md: 2, lg: 3)),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(20, xs: 15, sm: 18, md: 22, lg: 25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assessment Points',
                      style: TextStyle(
                        fontSize: context.fontSize(16, xs: 10, sm: 12, md: 14, lg: 16, xl: 18),
                        color: context.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: context.fontSize(28, xs: 20, sm: 24, md: 28, lg: 32, xl: 36),
                            color: context.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
                        Image.asset(
                          'assets/icons/score_icon.png',
                          width: context.iconSize(22, xs: 20, sm: 26, md: 30, lg: 34, xl: 38),
                          height: context.iconSize(22, xs: 20, sm: 26, md: 30, lg: 34, xl: 38),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.space(16, xs: 30, sm: 40, md: 50, lg: 60)),

            // Modular Section with Dropdown
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isModularExpanded = !isModularExpanded;
                    });
                  },
                  child: Container(
                    width: context.widthPercent(100),
                    height: context.breakpoint(
                      xs: context.heightPercent(6),
                      sm: context.heightPercent(7),
                      md: context.heightPercent(8),
                      lg: context.heightPercent(9),
                      xl: context.heightPercent(10),
                      fallback: context.heightPercent(10),
                    ),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(context.radius(8, xs: 8, sm: 10, md: 12, lg: 14)),
                        bottom: Radius.circular(
                          isModularExpanded 
                            ? 0 
                            : context.radius(8, xs: 8, sm: 10, md: 12, lg: 14),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: context.responsiveCombined(1, xs: 0.5, lg: 1.5),
                          blurRadius: context.responsiveCombined(5, xs: 3, lg: 8),
                          offset: Offset(0, context.responsiveCombined(3, xs: 2, lg: 4)),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.space(20, xs: 15, sm: 18, md: 22, lg: 25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/notebook-modules.png',
                                width: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                                height: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                              ),
                              SizedBox(width: context.space(10, xs: 8, sm: 9, md: 10, lg: 12)),
                              Text(
                                'Modular',
                                style: TextStyle(
                                  fontSize: context.fontSize(18, xs: 10, sm: 12, md: 14, lg: 18, xl: 20),
                                  color: context.whiteColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AnimatedRotation(
                            turns: isModularExpanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Image.asset(
                              'assets/icons/right-arrow.png',
                              width: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                              height: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Expandable section
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isModularExpanded
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.secondaryColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                context.radius(8, xs: 8, sm: 10, md: 12, lg: 14),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(
                            context.space(12, xs: 8, sm: 10, md: 12, lg: 16),
                          ),
                          child: Column(
                            children: [
                              _buildModuleItem(context, 'Module 1'),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.space(20, xs: 15, sm: 18, lg: 25),
                                ),
                                child: Divider(color: context.whiteColor),
                              ),
                              _buildModuleItem(context, 'Module 2'),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),

            // Divider
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: context.space(16, xs: 12, sm: 14, md: 16, lg: 20),
                ),
                width: context.widthPercent(12),
                height: context.responsiveCombined(7, xs: 5, sm: 6, lg: 8),
                decoration: BoxDecoration(
                  color: context.skyBlue,
                  borderRadius: BorderRadius.circular(
                    context.radius(10, xs: 8, sm: 9, lg: 12),
                  ),
                ),
              ),
            ),

            SizedBox(height: context.space(10, xs: 8, sm: 9, md: 10, lg: 12)),

            // Special Games Container
            Container(
              width: context.widthPercent(100),
              height: context.breakpoint(
                xs: context.heightPercent(6),
                sm: context.heightPercent(7),
                md: context.heightPercent(8),
                lg: context.heightPercent(9),
                xl: context.heightPercent(10),
                fallback: context.heightPercent(10),
              ),
              decoration: BoxDecoration(
                color: context.skyBlue,
                borderRadius: BorderRadius.circular(
                  context.radius(8, xs: 8, sm: 10, md: 12, lg: 14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.blackColor.withAlpha(60),
                    spreadRadius: context.responsiveCombined(1, xs: 0.5, lg: 1.5),
                    blurRadius: context.responsiveCombined(5, xs: 3, lg: 8),
                    offset: Offset(0, context.responsiveCombined(3, xs: 2, lg: 4)),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(20, xs: 15, sm: 18, md: 22, lg: 25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/puzzle_icon.png',
                          width: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                          height: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28, xl: 32),
                        ),
                        SizedBox(width: context.space(10, xs: 8, sm: 9, md: 10, lg: 12)),
                        Text(
                          'Special Games',
                          style: TextStyle(
                            fontSize: context.fontSize(18, xs: 10, sm: 12, md: 14, lg: 16, xl: 18),
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      width: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28),
                      height: context.iconSize(24, xs: 18, sm: 20, md: 24, lg: 28),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.space(32, xs: 24, sm: 28, md: 32, lg: 40)),

            // Alternative Games Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Alternative Games',
                      style: TextStyle(
                        fontSize: context.fontSize(12, xs: 10, sm: 12, md: 14, lg: 16, xl: 18),
                        fontWeight: FontWeight.w600,
                        color: context.skyBlue,
                      ),
                    ),
                    SizedBox(width: context.space(6, xs: 4, sm: 5, md: 6, lg: 8)),
                    Image.asset(
                      'assets/icons/info_icon.png',
                      width: context.iconSize(14, xs: 10, sm: 12, md: 14, lg: 16),
                      height: context.iconSize(14, xs: 10, sm: 12, md: 14, lg: 16),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/lock_icon.png',
                  width: context.iconSize(20, xs: 14, sm: 16, md: 18, lg: 22),
                  height: context.iconSize(20, xs: 14, sm: 16, md: 18, lg: 22),
                ),
              ],
            ),

            SizedBox(height: context.space(16, xs: 12, sm: 14, md: 16, lg: 20)),

            // Game Grid Layout
            if (context.isLgAndUp)
              // Desktop/Tablet: 4 games in one row
              Row(
                children: [
                  Expanded(child: _buildGameContainer(context, 'Game 1')),
                  SizedBox(width: context.space(12, lg: 16)),
                  Expanded(child: _buildGameContainer(context, 'Game 2')),
                  SizedBox(width: context.space(12, lg: 16)),
                  Expanded(child: _buildGameContainer(context, 'Game 3')),
                  SizedBox(width: context.space(12, lg: 16)),
                  Expanded(child: _buildGameContainer(context, 'Game 4')),
                ],
              )
            else
              // Mobile: 2x2 grid
              Column(
                children: [
                  // First row of game containers
                  Row(
                    children: [
                      Expanded(child: _buildGameContainer(context, 'Game 1')),
                      SizedBox(width: context.space(12, xs: 8, sm: 10, md: 12)),
                      Expanded(child: _buildGameContainer(context, 'Game 2')),
                    ],
                  ),
                  SizedBox(height: context.space(12, xs: 8, sm: 10, md: 12)),
                  // Second row of game containers
                  Row(
                    children: [
                      Expanded(child: _buildGameContainer(context, 'Game 3')),
                      SizedBox(width: context.space(12, xs: 8, sm: 10, md: 12)),
                      Expanded(child: _buildGameContainer(context, 'Game 4')),
                    ],
                  ),
                ],
              ),

            // Bottom padding to ensure content isn't cut off
            SizedBox(height: context.space(20, xs: 15, sm: 18, md: 20, lg: 25)),
          ],
        ),
      ),
    );
  }

  // Enhanced game container builder
  Widget _buildGameContainer(BuildContext context, String gameName) {
    return Container(
      height: context.breakpoint(
        xs: context.heightPercent(11),
        sm: context.heightPercent(10),
        md: context.heightPercent(9),
        lg: context.heightPercent(12),
        xl: context.heightPercent(10),
        fallback: context.heightPercent(11),
      ),
      decoration: BoxDecoration(
        color: context.skyBlue,
        borderRadius: BorderRadius.circular(
          context.radius(8, xs: 8, sm: 10, md: 12, lg: 14),
        ),
        boxShadow: [
          BoxShadow(
            color: context.blackColor.withAlpha(60),
            spreadRadius: context.responsiveCombined(1, xs: 0.5, lg: 1.5),
            blurRadius: context.responsiveCombined(5, xs: 3, lg: 8),
            offset: Offset(0, context.responsiveCombined(3, xs: 2, lg: 4)),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/gamepad_icon.png',
            width: context.iconSize(32, xs: 24, sm: 28, md: 32, lg: 40, xl: 48),
            height: context.iconSize(32, xs: 24, sm: 28, md: 32, lg: 40, xl: 48),
            color: context.whiteColor,
          ),
          SizedBox(height: context.space(6, xs: 4, sm: 5, md: 6, lg: 8)),
          Text(
            gameName,
            style: TextStyle(
              fontSize: context.fontSize(14, xs: 8, sm: 10, md: 12, lg: 14, xl: 16),
              color: context.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced module item builder
  Widget _buildModuleItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Navigate to LessonScreen with consistent transition animation
        Navigator.push(
          context,
          SlideRightLeftRoute(
            page: LessonScreen(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.space(8, xs: 6, sm: 7, md: 8, lg: 10),
          horizontal: context.space(20, xs: 6, sm: 8, md: 10, lg: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/notebook-modules-2.png',
                  color: context.whiteColor,
                  width: context.iconSize(22, xs: 16, sm: 18, md: 20, lg: 26),
                  height: context.iconSize(22, xs: 16, sm: 18, md: 20, lg: 26),
                ),
                SizedBox(width: context.space(10, xs: 8, sm: 9, md: 10, lg: 12)),
                Text(
                  title,
                  style: TextStyle(
                    color: context.whiteColor,
                    fontSize: context.fontSize(14, xs: 11, sm: 12, md: 14, lg: 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.whiteColor,
              size: context.iconSize(18, xs: 14, sm: 16, md: 18, lg: 20),
            ),
          ],
        ),
      ),
    );
  }
}