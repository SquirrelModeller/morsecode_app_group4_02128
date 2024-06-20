import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/medium_training_service.dart';
import 'package:vibration/vibration.dart';

class MediumTraining extends StatefulWidget {
  const MediumTraining({super.key});

  @override
  State<MediumTraining> createState() => _MediumTrainingState();
}

class _MediumTrainingState extends State<MediumTraining> {
  MediumTrainingService mediumTraining = MediumTrainingService();

  @override
  void initState() {
    super.initState();
    mediumTraining.initFourRandomLetters();
  }

  void vibrate() {
    mediumTraining.initFourRandomLetters();
    var morseCode = mediumTraining.correctMorseCode;
    List<int> vibration = [];
    for (var c in morseCode) {
      vibration.add(130);
      if (c == MorseState.Dot) {
        vibration.add(130);
      } else {
        vibration.add(390);
      }
    }
    print(morseCode);
    print(vibration);
    Vibration.vibrate(
      pattern: vibration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                vibrate();
              },
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
