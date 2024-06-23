import 'package:flutter/material.dart';

class CustomSkipButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const CustomSkipButton({
    super.key,
    required this.isDarkMode,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Skip'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: isDarkMode
          ? const Color.fromRGBO(5, 94, 132, 1)
          : const Color.fromARGB(255, 0, 178, 255),
      ),
    );
  }
}
