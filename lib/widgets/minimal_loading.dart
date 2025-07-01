import 'package:flutter/material.dart';
import 'package:physica_app/utils/colors.dart';
import 'package:physica_app/utils/media_query.dart';

class MinimalLoadingIndicator extends StatefulWidget {
  final String? message;
  final Color? color;
  final double? size;

  const MinimalLoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 24.0
  }) : super(key: key);

  @override
  State<MinimalLoadingIndicator> createState() => _MinimalLoadingIndicatorState();
}

class _MinimalLoadingIndicatorState extends State<MinimalLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
    
    _animController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.primaryColor;
    
    return Center(
      child: Container(
        padding: EdgeInsets.all(context.responsive(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return _buildMinimalLoader(color);
              },
            ),
            if (widget.message != null) ...[
              SizedBox(height: context.responsive(12)),
              Text(
                widget.message!,
                style: TextStyle(
                  color: context.skyBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ]
          ],
        ),
      ),
    );
  }
  
  Widget _buildMinimalLoader(Color color) {
    return SizedBox(
      height: widget.size! * 1.8,
      width: widget.size! * 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) {
            // Stagger the animations slightly
            final delayedValue = (_animation.value - (0.3 * index)).clamp(0.0, 1.0);
            final size = widget.size! * (0.6 + (delayedValue * 0.4));
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size! * 0.3),
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2 + (delayedValue * 0.8)),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}