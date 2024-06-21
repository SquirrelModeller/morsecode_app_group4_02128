import 'package:flutter/material.dart';
import 'package:morsetorch/screens/beginner_morse_training.dart';
import 'package:morsetorch/screens/intermediate_training.dart';
import 'package:morsetorch/screens/morse_training.dart';

class MorseTrainingSelectorPage extends StatefulWidget {
  bool isDarkMode;

  MorseTrainingSelectorPage({super.key, required this.isDarkMode});

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
      return BeginnerMorseTrainingPage(setScreen: setCurrentScreen, isDarkMode: widget.isDarkMode,);
    } else if (_currentScreen == 2) {
      return IntermediateTraining(
        setScreen: setCurrentScreen,
        isDarkMode: widget.isDarkMode,
      );
    } else if (_currentScreen == 3) {
      return MorseTrainingPage(
        setScreen: setCurrentScreen,
        isDarkMode: widget.isDarkMode,
      );
    } else {
      return Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 1;
                    });
                  },
                  child: Text(
                    'Beginner',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 35),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 2;
                    });
                  },
                  child: Text(
                    'Intermediate',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 35),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 3;
                    });
                  },
                  child: Text(
                    'Advanced',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 35),
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
