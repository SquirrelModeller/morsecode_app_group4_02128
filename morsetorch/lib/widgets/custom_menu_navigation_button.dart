import 'package:flutter/material.dart';

class CustomMenuNavigationButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;
  final String buttonText;

  const CustomMenuNavigationButton({
    super.key,
    required this.isDarkMode,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.width / 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor:
                isDarkMode ? const Color.fromARGB(255, 5, 20, 36) : Colors.white,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 15,
              color: isDarkMode
                  ? Colors.white
                  : const Color.fromARGB(255, 5, 20, 36),
            ),
          ),
        ),
      ),
    );
  }
}
