import 'package:flutter/material.dart';
import 'package:morsetorch/screens/beginner_morse_training.dart';
import 'package:morsetorch/screens/intermediate_training.dart';
import 'package:morsetorch/screens/morse_practice_timing_screen.dart';
import 'package:morsetorch/screens/morse_training.dart';
import 'package:morsetorch/widgets/custom_menu_navigation_button.dart';

class MorseTrainingSelectorPage extends StatefulWidget {
  final bool isDarkMode;

  MorseTrainingSelectorPage({super.key, required this.isDarkMode});

  @override
  MorseTrainingSelectorPageState createState() =>
      MorseTrainingSelectorPageState();
}

class MorseTrainingSelectorPageState extends State<MorseTrainingSelectorPage> {
  int _currentScreen = 0;

  // Define a map of screen widgets
  Map<int, Widget Function()> get screenWidgets => {
        1: () => BeginnerMorseTrainingPage(
            setScreen: changeScreen, isDarkMode: widget.isDarkMode),
        2: () => IntermediateTraining(
            setScreen: changeScreen, isDarkMode: widget.isDarkMode),
        3: () => MorseTrainingPage(
            setScreen: changeScreen, isDarkMode: widget.isDarkMode),
        4: () => MorsePracticeTimingScreen(
            setScreen: changeScreen, isDarkMode: widget.isDarkMode),
      };

  void changeScreen(int newScreen) {
    setState(() => _currentScreen = newScreen);
  }

  @override
  Widget build(BuildContext context) {
    // Use screenWidgets map to fetch the appropriate widget
    Widget content = screenWidgets[_currentScreen]?.call() ?? buildHomeScreen();
    return content;
  }

  Widget buildHomeScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 15),
            CustomMenuNavigationButton(
                isDarkMode: widget.isDarkMode,
                onPressed: () => changeScreen(1),
                buttonText: 'Morse Match'),
            CustomMenuNavigationButton(
                isDarkMode: widget.isDarkMode,
                onPressed: () => changeScreen(2),
                buttonText: 'Buzz Code'),
            CustomMenuNavigationButton(
                isDarkMode: widget.isDarkMode,
                onPressed: () => changeScreen(3),
                buttonText: 'Tap n\' Type'),
            CustomMenuNavigationButton(
                isDarkMode: widget.isDarkMode,
                onPressed: () => changeScreen(4),
                buttonText: 'Morse Timing Practice'),
          ],
        ),
      ),
    );
  }
}
