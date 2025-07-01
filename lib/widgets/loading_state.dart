import 'dart:math' as math;

import 'package:flutter/material.dart';

class BouncingDotsLoading extends StatefulWidget {
  final Color? backgroundColor;
  final double dotSize;
  final double size;
  final Color? color;
  final String? message;

  const BouncingDotsLoading({
    Key? key,
    this.backgroundColor,
    this.dotSize = 10.0,
    this.color,
    this.size = 70.0,
    this.message,
    }) : super(key: key);

  @override
  State<BouncingDotsLoading> createState() => _BouncingDotsLoadingState();
}

class _BouncingDotsLoadingState extends State<BouncingDotsLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int dotsCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final backgroundColor =  widget.backgroundColor ?? Colors.transparent;
    final dotWidth = widget.dotSize * 2;
    final dotMargin = widget.dotSize;

    final totalWidth = (dotWidth * dotsCount) + (dotMargin * 2 * (dotsCount - 1));
    final containerWidth = math.max(widget.size, totalWidth + 10.0);
    return Container(
      color: backgroundColor,
      width: containerWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.size * 0.6,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    dotsCount,
                    (index) => _buildAnimatedDot(index, color),
                  )
                ),
              ),
            ),

            if (widget.message != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Text(
                widget.message!,
                style: TextStyle(
                  color: color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(int index, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.dotSize),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {

          final phaseOffset = index * 0.33;
          final t = ((_controller.value + phaseOffset) % 1.0);
          
          final bounce = math.sin(t * 2 * math.pi) * (widget.size * 0.12);

          final scale = 1.0 - (math.cos(t * 2 * math.pi) * 0.005);

          final opacity = 0.7 + (math.sin(t * 2 * math.pi) * 0.3).abs();
          final opacityInt = (opacity * 255).round();

          return Transform.translate(
            offset: Offset(0, bounce),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: widget.dotSize * 2,
                height: widget.dotSize * 2,
                decoration: BoxDecoration(
                  color: color.withAlpha(opacityInt),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 1 + bounce * 0.1),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}