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
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPercent(5),
                vertical: context.heightPercent(2),
              ),
              child: Center(
                child: Text(
                  'Augmented Reality',
                  style: TextStyle(
                    color: context.skyBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsive(8),
                  ),
                ),
              ),
            ),
            
            // Main content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPercent(5),
                vertical: context.heightPercent(2),
              ),
              child: Column(
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
          width: context.widthPercent(25),
          height: context.widthPercent(25), // Same as width to make it square
          decoration: BoxDecoration(
            border: Border.all(
              color: context.skyBlue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: context.widthPercent(12),
              height: context.widthPercent(12),
              color: context.skyBlue,
            ),
          ),
        ),
        
        // Label below container
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: context.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}