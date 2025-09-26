import 'package:flutter/material.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  
  const BottomNavBar({
    Key? key,
    required this.currentIndex, 
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.buttonHeight(
        48,
        xs: 48,
        sm: 50,
        md: 52,
        lg: 54,
        xl: 56,
        xxl: 58,
      ) + context.bottomPadding,
      padding: EdgeInsets.only(
        bottom: context.bottomPadding
      ),
      decoration: BoxDecoration(
        color: context.skyBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: context.space(12),
            spreadRadius: 0,
            offset: Offset(0, context.space(-2)),
          )
        ]
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 'Home', 'assets/icons/home_icon.png', 0),
          _buildNavItem(context, 'AR', 'assets/icons/ar_icon.png', 1),
          _buildNavItem(context, 'Profile', 'assets/icons/profile_icon.png', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String iconPath, int index) {
    final isSelected = widget.currentIndex == index;

    return Semantics(
      label: '$label tab, ${isSelected ? 'selected' : 'not selected'}',
      selected: isSelected,
      child: InkWell(
        onTap: () {
          widget.onTap(index);
        },
        borderRadius: BorderRadius.circular(context.radius(16)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: context.space(isSelected ? 12 : 10),
            vertical: context.space(6),
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(context.radius(16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: context.iconSize(24, xs: 16, sm: 18, md: 20, lg: 22, xl: 24, xxl: 26),
                height: context.iconSize(24, xs: 16, sm: 18, md: 20, lg: 22, xl: 24, xxl: 26),
                color: isSelected ? context.whiteColor : context.whiteColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _fallbackIcon(label),
                    size: context.iconSize(28, xs: 24, sm: 18, lg: 30, xl: 32),
                    color: isSelected ? context.whiteColor : context.whiteColor,
                  );
                },
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: 0,),
                secondChild: Row(
                  children: [
                    SizedBox(width: context.space(6, xs: 6, sm: 7, md: 8, lg: 9, xl: 10, xxl: 11)),
                    Text(
                      label,
                      style: TextStyle(
                        color: context.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: context.fontSize(16, xs: 10, sm: 12, md: 14, lg: 16, xl: 18, xxl: 20),
                      ),
                    )
                  ],
                ),
                crossFadeState: isSelected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData _fallbackIcon(String label) {
    switch(label.toLowerCase()) {
      case 'home' :
        return Icons.home;

      case 'ar' :
        return Icons.view_in_ar_rounded;

      case 'profile' :
        return Icons.person;

      default:
        return Icons.help_outline;
    }
  }
}