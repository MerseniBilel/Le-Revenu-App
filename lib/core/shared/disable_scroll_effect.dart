import 'package:flutter/material.dart';

class DisbleScrollEffect extends StatelessWidget {
  final Widget child;
  const DisbleScrollEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification notification) {
        notification.disallowIndicator();
        return true;
      },
      child: child,
    );
  }
}
