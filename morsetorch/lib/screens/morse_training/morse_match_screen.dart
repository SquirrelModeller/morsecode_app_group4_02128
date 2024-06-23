import 'package:flutter/material.dart';
import 'package:morsetorch/services/morse_match_service.dart';
import 'package:morsetorch/widgets/costum_skip_button.dart';
import 'package:morsetorch/widgets/custom_back_button.dart';
import 'package:morsetorch/widgets/custom_multiple_choice_button.dart';

class MorseMatchScreen extends StatefulWidget {
  final Function(int) setScreen;
  final bool isDarkMode;

  const MorseMatchScreen(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  State<MorseMatchScreen> createState() => _MorseMatchScreenState();
}

class _MorseMatchScreenState extends State<MorseMatchScreen> {
  MorseMatchService beginnerTrainingService = MorseMatchService();
  int streak = 0;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    setUpGame();
  }

  void setUpGame() {
    beginnerTrainingService.setUpGame();
  }

  void disableButtonTemporarily() {
    setState(() {
      isButtonEnabled = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isButtonEnabled = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBackButton(
              isDarkMode: widget.isDarkMode,
              onPressed: () => widget.setScreen(0)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: beginnerTrainingService.correctLetter,
                  builder: (_, letter, __) => Text(
                    'Guess the character: $letter',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 118, 118, 118),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                buildChoiceButtons(0, 1),
                const SizedBox(height: 30),
                buildChoiceButtons(2, 3),
                const SizedBox(height: 30),
                CustomSkipButton(
                  onPressed: () {
                    beginnerTrainingService.increaseStreak(false);
                    setUpGame();
                  },
                  isDarkMode: widget.isDarkMode,
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<int>(
                  valueListenable: beginnerTrainingService.streak,
                  builder: (_, streak, __) => Text(
                    "Streak: $streak",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 118, 118, 118),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildChoiceButtons(int firstIndex, int secondIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ValueListenableBuilder<List<String>>(
          valueListenable: beginnerTrainingService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: beginnerTrainingService.answerList,
            builder: (_, answerList, __) => CustomMultipleChoiceButton(
              text: choiceList[firstIndex],
              correctAnswer: answerList[firstIndex],
              reset: setUpGame,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: beginnerTrainingService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: beginnerTrainingService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: beginnerTrainingService.answerList,
            builder: (_, answerList, __) => CustomMultipleChoiceButton(
              text: choiceList[secondIndex],
              correctAnswer: answerList[secondIndex],
              reset: setUpGame,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: beginnerTrainingService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
      ],
    );
  }
}
