import 'package:flutter/material.dart';
import 'package:morsetorch/services/morsetraining_service.dart';

class MorseTrainingPage extends StatefulWidget {
  const MorseTrainingPage({super.key});

  @override
  _MorseTrainingPageState createState() => _MorseTrainingPageState();
}

class _MorseTrainingPageState extends State<MorseTrainingPage> {
  final MorseTraining _morseTraining = MorseTraining();

  Color color1 = Colors.blue;

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
        color1 = Colors.blue;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap to Morse'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<String>(
              valueListenable: _morseTraining.wordToType,
              builder: (_, word, __) => Text('Word to type: $word',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<String>(
                  valueListenable: _morseTraining.characterTyped,
                  builder: (_, typed, __) {
                    return ValueListenableBuilder<String>(
                      valueListenable: _morseTraining.builder,
                      builder: (_, typedString, __) => Text(
                          'Current Input: $typedString $typed',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.blue)),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder<String>(
                valueListenable: _morseTraining.characterTyped,
                builder: (_, typed, __) => Text(
                    '${_morseTraining.convertMorseStateEnumToString()}',
                    style: const TextStyle(fontSize: 100, color: Colors.blue)),
              ),
            ),
            GestureDetector(
              onTapDown: (_) => {handlePress(true), }, 
              onTapUp: (_) => handlePress(false),
              onTapCancel: () => handlePress(false),
              child: Container(
                width: 150,
                height: 150,
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
            const SizedBox(height: 40),
            FloatingActionButton(
              onPressed: () {
                _morseTraining.beginTraining();
              },
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
