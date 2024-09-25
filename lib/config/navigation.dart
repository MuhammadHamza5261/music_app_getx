import 'package:flutter/material.dart';

class NavigationHelper {
  // Method to navigate to another screen
  static void navigateToScreen(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
