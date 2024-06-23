import 'package:flutter/material.dart';

class CostumSnackBar {
  void showSnackBar(String message, BuildContext context) {
    Future.microtask(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
