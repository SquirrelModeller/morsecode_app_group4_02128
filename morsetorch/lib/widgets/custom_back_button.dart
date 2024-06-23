import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const CustomBackButton({
    super.key,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 35,
      left: 20,
      child: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          backgroundColor:
              isDarkMode ? const Color.fromARGB(255, 5, 20, 36) : Colors.white,
          onPressed: onPressed,
          child: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 118, 118, 118),
          ),
        ),
      ),
    );
  }
}
