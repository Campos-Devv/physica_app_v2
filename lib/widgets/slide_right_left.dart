import 'package:flutter/material.dart';

class SlideRightLeftRoute extends PageRouteBuilder {
  final Widget page;
  
  SlideRightLeftRoute({required this.page})
    : super(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween =  Tween(begin: begin, end: end);
        final curve = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

        return SlideTransition(
          position: tween.animate(curve),
          child: child,
        );
      },
    );
}