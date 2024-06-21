import 'package:flutter/material.dart';

class MultipleChoiceButton extends StatefulWidget {
  final String text;
  final bool correctAnswer;
  var whenPressed;
  var isEnabled;
  var streak;

  MultipleChoiceButton(
      {super.key,
      required this.text,
      required this.correctAnswer,
      this.whenPressed,
      this.isEnabled = true,
      this.streak});

  @override
  _MultipleChoiceButtonState createState() => _MultipleChoiceButtonState();
}

class _MultipleChoiceButtonState extends State<MultipleChoiceButton> {
  Color _buttonColor = Color.fromARGB(255, 0, 178, 255);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        backgroundColor: _buttonColor,
        onPressed: widget.isEnabled
            ? () async {
                widget.whenPressed();
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
                setState(() {
                  _buttonColor = Color.fromARGB(255, 0, 178, 255);
                });
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
