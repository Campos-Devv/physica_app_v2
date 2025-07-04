import 'package:flutter/material.dart';
import 'package:physica_app/utils/colors.dart';

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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottomPadding,
      padding: EdgeInsets.only(
        bottom: bottomPadding
      ),
      decoration: BoxDecoration(
        color: context.skyBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -2),
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
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 12 :10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: isSelected ? context.whiteColor : context.whiteColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _fallbackIcon(label),
                    size: 28,
                    color: isSelected ? context.whiteColor : context.whiteColor,
                  );
                },
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: 0,),
                secondChild: Row(
                  children: [
                    const SizedBox(width: 6,),
                    Text(
                      label,
                      style: TextStyle(
                        color: context.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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