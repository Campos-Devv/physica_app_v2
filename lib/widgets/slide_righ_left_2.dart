import 'package:flutter/material.dart';

class SlideRightLeft2 extends PageRouteBuilder{
  final Widget enterPage;
  final Widget exitPage;

  SlideRightLeft2({required this.enterPage, required this.exitPage})
      : super(
        pageBuilder:(context, animation, secondaryAnimation) => enterPage,
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const beginFirst = Offset.zero;
          const endFirst = Offset(-1.0, 0.0);

          final tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          final firstTween = Tween<Offset>(begin: beginFirst, end: endFirst).chain(CurveTween(curve: Curves.easeInOut));

          final dimAnimation = animation.drive(
            Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeInOut))
          );

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                SlideTransition(
                  position: animation.drive(firstTween),
                  child: exitPage,
                  
                ),
                FadeTransition(
                  opacity: dimAnimation,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                )
              ],
            ),
          );
        }
      );
}