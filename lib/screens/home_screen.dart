import 'package:flutter/material.dart';
import 'package:physica_app/screens/ar_samples.dart';
import 'package:physica_app/screens/lessons.dart'; // Add this import
import 'package:physica_app/screens/profile.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/navigation.dart';
import 'package:physica_app/widgets/slide_righ_left_2.dart';
import 'package:physica_app/widgets/slide_right_left.dart';

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
          height: MediaQuery.of(context).size.height,
          color: context.whiteColor,
          child: _getBody()
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(
        left: context.responsive(5) + context.widthPercent(5),
        right: context.responsive(5) + context.widthPercent(5),
        top: context.responsive(15) + context.heightPercent(0),
      ),
      child: SingleChildScrollView(  // Add SingleChildScrollView here
        physics: BouncingScrollPhysics(),  // Add smooth scroll physics
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: context.responsive(10),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    ),
                  
                    SizedBox(width: context.responsive(3)),
                  
                    Text(
                      'Doe',
                      style: TextStyle(
                        fontSize: context.responsive(10),
                        fontWeight: FontWeight.w500,
                        color: context.skyBlue,
                      ),
                    )
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.skyBlue,
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: context.responsive(14),
                    backgroundColor: context.skyBlue,
                    backgroundImage: AssetImage(
                      'assets/images/profile_picture.jpg',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.responsive(10)),

            Container(
              width: context.widthPercent(100),
              height: context.heightPercent(12),
              decoration: BoxDecoration(
                color: context.skyBlue,
                borderRadius: BorderRadius.circular(context.responsive(4)),
                boxShadow: [
                  BoxShadow(
                    color: context.skyBlue.withAlpha(128),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ]
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPercent(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      'Assessment Points',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 28,
                            color: context.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: context.responsive(5)),

                        Image.asset(
                          'assets/icons/score_icon.png',
                          width: context.responsive(14),
                          height: context.responsive(14),
                        ),
                      ],
                    ),
          
                    
                  ],
                ),
              ),
            ),

            SizedBox(height: context.responsive(10)),

            // Updated Modular container with dropdown
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
                    height: context.heightPercent(10),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(context.responsive(4)),
                        bottom: Radius.circular(isModularExpanded ? 0 : context.responsive(4))
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/notebook-modules.png',
                                width: context.responsive(16),
                                height: context.responsive(16),
                              ),
                            
                              SizedBox(
                                width: context.responsive(5),
                              ),
                            
                              Text(
                                'Modular',
                                style: TextStyle(
                                  fontSize: 18,
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
                              width: context.responsive(16),
                              height: context.responsive(16),
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
                            bottom: Radius.circular(context.responsive(4))
                          ),
                        ),
                        padding: EdgeInsets.all(context.responsive(5)),
                        child: Column(
                          children: [
                            _buildModuleItem(context, 'Module 1'),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPercent(5),
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
            
            // Sky blue divider with short width
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: context.responsive(8)),
                width: context.widthPercent(12),
                height: 7,
                decoration: BoxDecoration(
                  color: context.skyBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: context.responsive(5)),

            // Special Game container (static, no dropdown)
            Container(
              width: context.widthPercent(100),
              height: context.heightPercent(10),
              decoration: BoxDecoration(
                color: context.skyBlue,
                borderRadius: BorderRadius.circular(context.responsive(4)),
                boxShadow: [
                  BoxShadow(
                    color: context.blackColor.withAlpha(60),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3)
                  )
                ]
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPercent(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/puzzle_icon.png',
                          width: context.responsive(16),
                          height: context.responsive(16),
                        ),
                      
                        SizedBox(
                          width: context.responsive(5),
                        ),
                      
                        Text(
                          'Special Games',
                          style: TextStyle(
                            fontSize: 18,
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      width: context.responsive(16),
                      height: context.responsive(16),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.responsive(20)),

            // Alternative games section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Alternative Games',
                      style: TextStyle(
                        fontSize: context.responsive(6),
                        fontWeight: FontWeight.w600,
                        color: context.skyBlue,
                      ),
                    ),

                    SizedBox(width: context.responsive(3)),

                    Image.asset(
                      'assets/icons/info_icon.png',
                      width: context.responsive(7),
                      height: context.responsive(7),
                    )
                  ],
                ),

                Image.asset(
                  'assets/icons/lock_icon.png',
                  width: context.responsive(10),
                  height: context.responsive(10),
                ),
              ],
            ),

            SizedBox(height: context.responsive(10)),

            // First row of game containers
            Row(
              children: [
                // First container
                Expanded(
                  child: Container(
                    height: context.heightPercent(11),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.circular(context.responsive(4)),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/gamepad_icon.png',
                          width: context.responsive(20),
                          height: context.responsive(20),
                          color: context.whiteColor,
                        ),
                        SizedBox(height: context.responsive(3)),
                        Text(
                          'Game 1',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: context.widthPercent(4)), // Fixed spacing between containers
                
                // Second container
                Expanded(
                  child: Container(
                    height: context.heightPercent(11),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.circular(context.responsive(4)),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/gamepad_icon.png',
                          width: context.responsive(20),
                          height: context.responsive(20),
                          color: context.whiteColor,
                        ),
                        SizedBox(height: context.responsive(3)),
                        Text(
                          'Game 2',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Add spacing between the rows
            SizedBox(height: context.responsive(8)),
            
            // Second row of game containers
            Row(
              children: [
                // Third container
                Expanded(
                  child: Container(
                    height: context.heightPercent(11),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.circular(context.responsive(4)),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/gamepad_icon.png',
                          width: context.responsive(20),
                          height: context.responsive(20),
                          color: context.whiteColor,
                        ),
                        SizedBox(height: context.responsive(3)),
                        Text(
                          'Game 3',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: context.widthPercent(4)), // Fixed spacing between containers
                
                // Fourth container
                Expanded(
                  child: Container(
                    height: context.heightPercent(11),
                    decoration: BoxDecoration(
                      color: context.skyBlue,
                      borderRadius: BorderRadius.circular(context.responsive(4)),
                      boxShadow: [
                        BoxShadow(
                          color: context.blackColor.withAlpha(60),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/gamepad_icon.png',
                          width: context.responsive(20),
                          height: context.responsive(20),
                          color: context.whiteColor,
                        ),
                        SizedBox(height: context.responsive(3)),
                        Text(
                          'Game 4',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Add bottom padding to ensure the content isn't cut off at the bottom
            SizedBox(height: context.responsive(10)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Navigate to LessonScreen with consistent transition animation
        Navigator.push(
          context,
          SlideRightLeftRoute(
            page: LessonScreen(),
          )
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.heightPercent(1),
          horizontal: context.widthPercent(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/notebook-modules-2.png',
                  color: context.whiteColor,
                  width: context.responsive(15),
                  height: context.responsive(15),
                ),
                SizedBox(
                  width: context.responsive(5),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: context.whiteColor,
                    fontSize: context.responsive(7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.whiteColor,
              size: context.responsive(12),
            )
          ],
        ),
      ),
    );
  }
}