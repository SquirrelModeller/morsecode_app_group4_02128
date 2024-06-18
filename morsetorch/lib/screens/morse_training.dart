import 'package:flutter/material.dart';
import 'package:morsetorch/services/morsetraining_service.dart';

class MorseTrainingPage extends StatefulWidget {
  const MorseTrainingPage({super.key});

  @override
  _MorseTrainingPageState createState() => _MorseTrainingPageState();
}

class _MorseTrainingPageState extends State<MorseTrainingPage> {
  final MorseTraining _morseTraining = MorseTraining();

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
    } else {
      _morseTraining.release();
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
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<String>(
                valueListenable: _morseTraining.builder,
                builder: (_, input, __) => Text('Current Input: $input',
                    style: const TextStyle(fontSize: 20, color: Colors.blue)),
              ),
            ),
            GestureDetector(
              onTapDown: (_) => handlePress(true),
              onTapUp: (_) => handlePress(false),
              onTapCancel: () => handlePress(false),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    'Tap Here',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                _morseTraining.resetBuilder();
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
