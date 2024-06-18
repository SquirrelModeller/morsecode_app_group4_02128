import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';
import 'dart:async';
import 'package:english_words/english_words.dart';



class Practice extends StatefulWidget {
  const Practice({super.key,});


  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  String randomWord = WordPair.random().toString().toUpperCase();
  int letterCount = 0;

  String morsText = ""; // Declare morsText here
  String text = "";
  List<MorseState> morseCode = [];
  final Morsetranslator morsetranslator =
      Morsetranslator(); // Create an instance of Morsetranslator

  void updateMorseText(String newText) {
    setState(() {
      morsText = newText;
    });
  }

  void clearMorseText() {
    setState(() {
      morsText = "";
      morseCode.clear(); // Clear morseCode when clearing text
    });
  }

  void updateText(String newLetter) {
    setState(() {
      if (newLetter == randomWord[letterCount]) {
        text += newLetter;
        print(text);
        letterCount++;
      } else {
        print("Wrong letter");
      }

      if (letterCount == randomWord.length) {
        print("HUrray");
      }
    });
  }

  void clearText() {
    setState(() {
      text = "";
      print(text);
      letterCount = 0;
      clearMorseText();
    });
  }

  void skipWord() {
    setState(() {
      //New word
      randomWord = WordPair.random().toString().toUpperCase();
      clearText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              readOnly: true,
              enabled: false,
              controller: TextEditingController(text: randomWord),
            ),
            TextField(
              readOnly: true,
              enabled: false,
              controller: TextEditingController(text: morsText),
            ),
            TextField(
              readOnly: true,
              enabled: false,
              controller: TextEditingController(text: text),
            ),
            SizedBox(
              height: 20,
            ),
            PressDurationButton(
                updateMorseText: updateMorseText,
                clearMorseText:
                    clearMorseText, // Pass clearMorseText as a callback
                updateText: updateText, // Pass updateText as a callback
                morseCode: morseCode,
                morsetranslator: morsetranslator),
            FloatingActionButton(
              onPressed: () {
                clearText();
              },
              tooltip: 'Reset', // Tooltip message
              child: Icon(Icons.refresh), // Icon for the FloatingActionButton
            ),
            FloatingActionButton(
              onPressed: () {
                skipWord();
              },
              tooltip: 'Skip word', // Tooltip message
              child: Icon(Icons.arrow_back), // Icon for the FloatingActionButton
            ),
          ],
        ),
      ),
    );
  }
}

class PressDurationButton extends StatefulWidget {
  final Function(String)
      updateMorseText; // Callback function to update morsText
  final Function clearMorseText; // Callback function to clear morsText
  final Function(String) updateText; // Callback function to update text
  final List<MorseState> morseCode; // Declare morseCode as a parameter
  final Morsetranslator morsetranslator; // Pass the Morsetranslator instance

  const PressDurationButton(
      {Key? key,
      required this.updateMorseText,
      required this.clearMorseText,
      required this.updateText,
      required this.morseCode,
      required this.morsetranslator})
      : super(key: key);

  @override
  _PressDurationButtonState createState() => _PressDurationButtonState();
}

class _PressDurationButtonState extends State<PressDurationButton> {
  DateTime? _startTime;
  DateTime? _endTime;
  Timer? _timer; // Declare a Timer variable
  bool _pressedDown = false; //Change color of button
  bool _validMorseInput = false;

  String _tempLetter = "";

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    if (_validMorseInput) {
      _timer = Timer(Duration(seconds: 2), () {
        // This code will run after 2 seconds of inactivity
        print('Button not pressed for 2 seconds');
        widget.updateText(_tempLetter); // Use the callback to update text
        widget.clearMorseText();
        _tempLetter = "";
        // Push the letter to the string
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressedDown = true;
      _startTime = DateTime.now();
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _pressedDown = false;
      _endTime = DateTime.now();
      if (_startTime != null) {
        Duration pressDuration = _endTime!.difference(_startTime!);
        widget.morseCode.add(pressDuration <= Duration(milliseconds: 150)
            ? MorseState.Dot
            : MorseState.Dash);
        widget
            .updateMorseText(getMorseText());// Update morsText using callback
        print(
            'Button pressed for: ${pressDuration.inMilliseconds} milliseconds, morseCode: ${widget.morseCode}');

        try {
          _tempLetter = widget.morsetranslator.morseToText(widget.morseCode);
          print(_tempLetter);
          _validMorseInput = true;
        } on Exception catch (e) {
          print("Invalid input");
          _validMorseInput = false;
          widget.clearMorseText(); // Use the callback to clear morse text
          print("Hello ${this}");
          // Delete message
        }
      }
      _startTime = null;
      _endTime = null;
      _startTimer();
    });
  }

  String getMorseText() {
    String result = '';
    for (MorseState i in widget.morseCode) {
      result += i == MorseState.Dot ? '.' : '-';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: () {
        setState(() {
          _startTime = null;
          _endTime = null;
        });
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _pressedDown
              ? const Color.fromARGB(255, 6, 81, 142)
              : Colors.blue,
        ),
        child: Center(
          child: Text(
            'Tap Here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
