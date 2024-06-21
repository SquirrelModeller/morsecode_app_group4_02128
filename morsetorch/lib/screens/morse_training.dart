import 'package:flutter/material.dart';
import 'package:morsetorch/services/morsetraining_service.dart';

class MorseTrainingPage extends StatefulWidget {
  var setScreen;

  bool isDarkMode;

  MorseTrainingPage(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  _MorseTrainingPageState createState() => _MorseTrainingPageState();
}

class _MorseTrainingPageState extends State<MorseTrainingPage> {
  final MorseTraining _morseTraining = MorseTraining();

  Color color1 = Color.fromARGB(255, 0, 178, 255);

  @override
  void initState() {
    super.initState();
    _morseTraining.beginTraining();
  }

  @override
  void dispose() {
    _morseTraining.dispose();
    super.dispose();
  }

  void handlePress(bool isPressed) {
    if (isPressed) {
      _morseTraining.startedPress();
      setState(() {
        color1 = Colors.black;
      });
    } else {
      _morseTraining.release();
      setState(() {
        color1 = Color.fromARGB(255, 0, 178, 255);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 35,
          left: 20,
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: widget.isDarkMode
                  ? Color.fromARGB(255, 5, 20, 36)
                  : Colors.white,
              onPressed: () {
                widget.setScreen(0);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 118, 118, 118),
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              ValueListenableBuilder<String>(
                valueListenable: _morseTraining.wordToType,
                builder: (_, word, __) => Text(
                  'Word to type: $word',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ValueListenableBuilder<String>(
                    valueListenable: _morseTraining.characterTyped,
                    builder: (_, typed, __) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _morseTraining.builder,
                        builder: (_, typedString, __) => Text(
                            'Current Input: $typedString $typed',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 178, 255))),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: ValueListenableBuilder<String>(
                  valueListenable: _morseTraining.characterTyped,
                  builder: (_, typed, __) => Text(
                    '${_morseTraining.convertMorseStateEnumToString()}',
                    style: const TextStyle(
                      fontSize: 100,
                      color: Color.fromARGB(255, 0, 178, 255),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => handlePress(true),
                onTapUp: (_) => handlePress(false),
                onTapCancel: () => handlePress(false),
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color1,
                  ),
                  child: const Center(
                    child: Text(
                      'Tap Here',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  _morseTraining.beginTraining();
                },
                tooltip: 'Reset',
                backgroundColor: widget.isDarkMode
                    ? const Color.fromARGB(255, 5, 20, 36)
                    : Colors.white,
                child: const Icon(Icons.skip_next_rounded,
                    color: Color.fromARGB(255, 118, 118, 118)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
