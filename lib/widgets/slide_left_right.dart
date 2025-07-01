import 'package:flutter/widgets.dart';

class SlideLeftRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRightRoute({required this.page})
      : super(
        pageBuilder: (context, aninmation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));

          return SlideTransition(position: offsetAnimation, child: child);
        }
      );
}