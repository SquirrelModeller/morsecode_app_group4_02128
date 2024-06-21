import 'package:flutter/material.dart';

class MultipleChoiceButton extends StatefulWidget {
  final String text;
  final bool correctAnswer;
  var reset;
  var isEnabled;
  var streak;
  var disableButton;
  var isDarkMode;

  MultipleChoiceButton(
      {super.key,
      required this.text,
      required this.correctAnswer,
      this.reset,
      this.disableButton,
      this.isEnabled = true,
      this.streak,
      required this.isDarkMode});

  @override
  _MultipleChoiceButtonState createState() => _MultipleChoiceButtonState();
}

class _MultipleChoiceButtonState extends State<MultipleChoiceButton> {
  late Color _buttonColor;

  @override
  void initState() {
    super.initState();
    _buttonColor = widget.isDarkMode
        ? const Color.fromRGBO(5, 94, 132, 1)
        : const Color.fromARGB(255, 0, 178, 255);
  }

  @override
  void didUpdateWidget(MultipleChoiceButton oldWidget) {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Correct!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  // Handle incorrect answer
                  widget.streak(false);
                  setState(() {
                    _buttonColor = Colors.red;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                await Future.delayed(const Duration(seconds: 2));
                _updateButtonColor();
                widget.reset();
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
