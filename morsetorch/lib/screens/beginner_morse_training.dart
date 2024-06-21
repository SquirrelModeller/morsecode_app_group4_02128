import 'package:flutter/material.dart';
import 'package:morsetorch/services/beginner_training_service.dart';
import 'package:morsetorch/widgets/multiple_choice.dart';

class BeginnerMorseTrainingPage extends StatefulWidget {
  final Function(int) setScreen;
  bool isDarkMode;

  BeginnerMorseTrainingPage(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  State<BeginnerMorseTrainingPage> createState() =>
      _BeginnerMorseTrainingPageState();
}

class _BeginnerMorseTrainingPageState extends State<BeginnerMorseTrainingPage> {
  BeginnerTrainingService beginnerTrainingService = BeginnerTrainingService();
  int streak = 0;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    setUpGame();
  }

  void setUpGame() {
    print("reset");
    beginnerTrainingService.setUpGame();
  }

  void disableButtonTemporarily() {
    setState(() {
      isButtonEnabled = false;
    });
    Future.delayed(Duration(seconds: 2), () {
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
          Positioned(
            top: 35,
            left: 20,
            child: SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: widget.isDarkMode
                    ? const Color.fromARGB(255, 5, 20, 36)
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
                FloatingActionButton(
                  onPressed: () {
                    print("Hello");
                    beginnerTrainingService.increaseStreak(false);
                    setUpGame();
                  },
                  backgroundColor: widget.isDarkMode
                      ? const Color.fromARGB(255, 5, 20, 36)
                      : Colors.white,
                  child: const Icon(
                    Icons.skip_next,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
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
            builder: (_, answerList, __) => MultipleChoiceButton(
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
            builder: (_, answerList, __) => MultipleChoiceButton(
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
