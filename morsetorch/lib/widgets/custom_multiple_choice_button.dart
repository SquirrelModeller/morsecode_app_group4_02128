import 'package:flutter/material.dart';
import 'package:morsetorch/widgets/costum_snack_bar.dart';

class CustomMultipleChoiceButton extends StatefulWidget {
  final String text;
  final bool correctAnswer;
  final Function reset;
  final bool isEnabled;
  final Function streak;
  final Function disableButton;
  final bool isDarkMode;

  const CustomMultipleChoiceButton(
      {super.key,
      required this.text,
      required this.correctAnswer,
      required this.reset,
      required this.disableButton,
      this.isEnabled = true,
      required this.streak,
      required this.isDarkMode});

  @override
  _CustomMultipleChoiceButtonState createState() =>
      _CustomMultipleChoiceButtonState();
}

class _CustomMultipleChoiceButtonState
    extends State<CustomMultipleChoiceButton> {
  final CostumSnackBar costumSnackBar = CostumSnackBar();
  late Color _buttonColor;

  @override
  void initState() {
    super.initState();
    _buttonColor = widget.isDarkMode
        ? const Color.fromRGBO(5, 94, 132, 1)
        : const Color.fromARGB(255, 0, 178, 255);
  }

  @override
  void didUpdateWidget(CustomMultipleChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _updateButtonColor();
    }
  }

  void _updateButtonColor() {
    setState(() {
      _buttonColor = widget.isDarkMode
          ? const Color.fromRGBO(5, 94, 132, 1)
          : const Color.fromARGB(255, 0, 178, 255);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        backgroundColor: _buttonColor,
        onPressed: widget.isEnabled
            ? () async {
                widget.disableButton();
                if (widget.correctAnswer) {
                  // Handle correct answer
                  widget.streak(true);
                  setState(() {
                    _buttonColor = Colors.green;
                  });
                  costumSnackBar.showSnackBar("Correct!", context);
                  await Future.delayed(const Duration(seconds: 1));
                  widget.reset();
                } else {
                  // Handle incorrect answer
                  widget.streak(false);
                  setState(() {
                    _buttonColor = Colors.red;
                  });
                  costumSnackBar.showSnackBar("Incorrect!", context);
                  await Future.delayed(const Duration(seconds: 1));
                }
                _updateButtonColor();
              }
            : null,
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
