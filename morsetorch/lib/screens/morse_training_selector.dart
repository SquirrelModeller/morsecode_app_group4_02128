import 'package:flutter/material.dart';
import 'package:morsetorch/screens/beginner_morse_training.dart';
import 'package:morsetorch/screens/medium_training.dart';
import 'package:morsetorch/screens/morse_training.dart';

class MorseTrainingSelectorPage extends StatefulWidget {
  const MorseTrainingSelectorPage({super.key});

  @override
  MorseTrainingSelectorPageState createState() =>
      MorseTrainingSelectorPageState();
}

class MorseTrainingSelectorPageState extends State<MorseTrainingSelectorPage> {
  int _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(int newScreen) {
      setState(() {
        _currentScreen = newScreen;
      });
    }

    if (_currentScreen == 1) {
      return BeginnerMorseTrainingPage(setScreen: setCurrentScreen);
    } else if (_currentScreen == 2) {
      return MorseTrainingPage(setScreen: setCurrentScreen);
      //return MediumTraining();
    } else {
      return Scaffold(
        body: Center(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 9),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentScreen = 1;
                      });
                    },
                    child: Text(
                      'Beginner',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 9),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentScreen = 2;
                      });
                    },
                    child: Text(
                      'Advanced',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
