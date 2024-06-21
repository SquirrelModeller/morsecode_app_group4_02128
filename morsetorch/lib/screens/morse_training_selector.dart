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
      return BeginnerMorseTrainingPage(
        setScreen: setCurrentScreen,
        isDarkMode: widget.isDarkMode,
      );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    backgroundColor: widget.isDarkMode
                        ? const Color.fromARGB(255, 5, 20, 36)
                        : Colors.white,
                  ),
                  child: Text('Morse Match',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15),
                      selectionColor: const Color.fromARGB(255, 118, 118, 118)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: widget.isDarkMode
                          ? const Color.fromARGB(255, 5, 20, 36)
                          : Colors.white),
                  child: Text('Buzz Code',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15),
                      selectionColor: const Color.fromARGB(255, 118, 118, 118)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentScreen = 3;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: widget.isDarkMode
                          ? const Color.fromARGB(255, 5, 20, 36)
                          : Colors.white),
                  child: Text('Tap n\' Type',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15),
                      selectionColor: const Color.fromARGB(255, 118, 118, 118)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
