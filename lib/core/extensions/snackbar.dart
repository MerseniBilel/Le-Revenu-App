import 'package:flutter/material.dart';

extension SnackBarContext on BuildContext {
  /// Feedback for actions that are out of the scope of the test
  /// (search, article detail…): better than a dead tap.
  void showComingSoon(String subject) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$subject arrive bientôt.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1400),
        ),
      );
  }
}
