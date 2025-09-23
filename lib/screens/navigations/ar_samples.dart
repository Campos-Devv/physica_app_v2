import 'package:flutter/material.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';

class ArSamplesScreen extends StatefulWidget {
  const ArSamplesScreen({super.key});

  @override
  State<ArSamplesScreen> createState() => _ArSamplesScreenState();
}

class _ArSamplesScreenState extends State<ArSamplesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Removing AppBar
      body: SafeArea(
        child: Column(
          children: [
            // Custom header with only title, no back button
            Padding(
              padding: EdgeInsets.only(
                top: context.space(20, xs: 15, sm: 18, md: 30, lg: 40, xl: 60),
                bottom: context.space(10, xs: 8, sm: 9, md: 30, lg: 12, xl: 15),
                left: context.space(20, xs: 15, sm: 18, md: 30, lg: 40, xl: 60),
                right: context.space(20, xs: 15, sm: 18, md: 30, lg: 40, xl: 60),
              ),
              child: Center(
                child: Text(
                  'Augmented Reality',
                  style: TextStyle(
                    color: context.skyBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: context.fontSize(16, xs: 12, sm: 14, md: 16, lg: 18, xl: 20),
                  ),
                ),
              ),
            ),
            
            // Main content
            Column(
              children: [
                // Row with 3 AR sample containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildArSampleItem(context, 'assets/icons/ar_icon.png', 'Sun'),
                    _buildArSampleItem(context, 'assets/icons/ar_icon.png', 'Moon'),
                    _buildArSampleItem(context, 'assets/icons/ar_icon.png', 'Earth'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildArSampleItem(BuildContext context, String iconPath, String label) {
    return Column(
      children: [
        // Square container with outline border
        Container(
          width: context.breakpoint(
            xs: context.widthPercent(28),
            sm: context.widthPercent(26),
            md: context.widthPercent(24),
            lg: context.widthPercent(22),
            xl: context.widthPercent(20),
            fallback: context.widthPercent(25),
          ),
          height: context.breakpoint(
            xs: context.widthPercent(28),
            sm: context.widthPercent(26),
            md: context.widthPercent(24),
            lg: context.widthPercent(22),
            xl: context.widthPercent(20),
            fallback: context.widthPercent(25),
          ), // Same as width to make it square
          decoration: BoxDecoration(
            border: Border.all(
              color: context.skyBlue,
              width: context.responsiveCombined(2.0, xs: 1.5, sm: 1.8, md: 2.0, lg: 2.5, xl: 3.0),
            ),
            borderRadius: BorderRadius.circular(
              context.radius(8, xs: 8, sm: 10, md: 12, lg: 14, xl: 16),
            ),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: context.breakpoint(
                xs: context.widthPercent(12),
                sm: context.widthPercent(11),
                md: context.widthPercent(10),
                lg: context.widthPercent(9),
                xl: context.widthPercent(7),
                fallback: context.widthPercent(12),
              ),
              height: context.breakpoint(
                xs: context.widthPercent(12),
                sm: context.widthPercent(11),
                md: context.widthPercent(10),
                lg: context.widthPercent(9),
                xl: context.widthPercent(7),
                fallback: context.widthPercent(12),
              ),
              color: context.skyBlue,
            ),
          ),
        ),
        
        // Label below container
        SizedBox(height: context.space(8, xs: 6, sm: 7, md: 8, lg: 10)),
        Text(
          label,
          style: TextStyle(
            color: context.skyBlue,
            fontSize: context.fontSize(16, xs: 10, sm: 12, md: 14, lg: 16, xl: 18),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}