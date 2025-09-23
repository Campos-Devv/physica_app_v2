import 'package:flutter/material.dart';
import 'package:physica_app/screens/navigations/home_screen.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';
import 'package:physica_app/widgets/slide_left_right_2.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
 final Map<int, bool> expandedModules = {};
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: context.heightPercent(5),
            left: context.widthPercent(10),
            right: context.widthPercent(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        SlideLeftRight2(enterPage: HomeScreen(
                          currentIndex: 0,
                          onTap: (index) {},
                        ), exitPage: LessonScreen())
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: context.skyBlue,
                      size: 28,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Lessons',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.skyBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ),
                ],
              ),

              SizedBox(
                height: context.heightPercent(5),
              ),

              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildModuleWithDropdown(index);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: context.heightPercent(2.5),
                ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleWithDropdown(int moduleIndex){
    final bool isExpanded = expandedModules[moduleIndex] ?? false;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expandedModules[moduleIndex] = !isExpanded;
              
            });
          },
          child: Container(
            width: double.infinity,
            height: context.heightPercent(10),
            decoration: BoxDecoration(
              color: context.skyBlue,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.responsive(4)),
                bottom: Radius.circular(isExpanded ? 0 : context.responsive(4))
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
            padding: EdgeInsets.symmetric(horizontal: context.widthPercent(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/lesson_icon.png',
                      width: context.responsive(16),
                      height: context.responsive(16),
                    ),
            
                    SizedBox(
                      width: context.responsive(5),
                    ),
            
                    Text(
                      'Lesson ${moduleIndex + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        color: context.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
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

        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: isExpanded
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.secondaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(context.responsive(4))
                  ),
                ),
                margin: EdgeInsets.only(
                  bottom: context.heightPercent(2),
                ),
                padding: EdgeInsets.all(context.responsive(5)),
                child: Column(
                  children: [
                    _buildDropdownItem(context, 'Pre-Test'),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(5),
                      ),
                      child: Divider(color: context.whiteColor.withOpacity(0.2)),
                    ),
                    _buildDropdownItem(context, 'Lesson'),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPercent(5),
                      ),
                      child: Divider(color: context.whiteColor.withOpacity(0.2)),
                    ),
                    _buildDropdownItem(context, 'Post-Test'),
                  ],
                ),
            )
          : const SizedBox.shrink(),
        ),
      
      ],
    );
  }

  Widget _buildDropdownItem(BuildContext context, String title) {
    return Padding(
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
                _getIconForItem(title),
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
                  fontWeight: FontWeight.w400,
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
    );
  }

  String _getIconForItem(String title) {
      switch (title) {
        case 'Pre-Test':
          return 'assets/icons/test_icon.png';
        case 'Lesson':
          return 'assets/icons/summary_icon.png';
        case 'Post-Test':
          return 'assets/icons/test_icon.png';
        default:
          return '';
      }
  }
}