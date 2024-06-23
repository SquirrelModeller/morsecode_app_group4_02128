import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/intermediate_training_service.dart';
import 'package:morsetorch/widgets/custom_floating_action_button.dart';
import 'package:morsetorch/widgets/multiple_choice.dart';
import 'package:vibration/vibration.dart';

class IntermediateTraining extends StatefulWidget {
  final Function(int) setScreen;
  bool isDarkMode;

  IntermediateTraining(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  State<IntermediateTraining> createState() => _IntermediateTrainingState();
}

class _IntermediateTrainingState extends State<IntermediateTraining> {
  IntermediateTrainingService intermediateTrainingService =
      IntermediateTrainingService();

  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    intermediateTrainingService.setUptGame();
  }

  void vibrate() {
    var morseCode = intermediateTrainingService.correctMorseCode;
    var vibration = intermediateTrainingService.getVibration(morseCode);
    Vibration.vibrate(
      pattern: vibration,
    );
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
          CustomFloatingActionButton(isDarkMode: widget.isDarkMode, onPressed: () => widget.setScreen(0)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 30),
                          buildChoiceButtons(0, 1),
                          const SizedBox(height: 30),
                          buildChoiceButtons(2, 3),
                          const SizedBox(height: 30),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Press to Vibrate",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                FloatingActionButton(
                  onPressed: () {
                    vibrate();
                  },
                  backgroundColor: widget.isDarkMode
                      ? const Color.fromARGB(255, 5, 20, 36)
                      : Colors.white,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    intermediateTrainingService.increaseStreak(false);
                    intermediateTrainingService.skip();
                  },
                  backgroundColor: widget.isDarkMode
                      ? const Color.fromARGB(255, 5, 20, 36)
                      : Colors.white,
                  child: const Icon(
                    Icons.skip_next,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: intermediateTrainingService.streak,
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
          valueListenable: intermediateTrainingService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: intermediateTrainingService.answerList,
            builder: (_, answerList, __) => MultipleChoiceButton(
              text: choiceList[firstIndex],
              correctAnswer: answerList[firstIndex],
              reset: intermediateTrainingService.skip,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: intermediateTrainingService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: intermediateTrainingService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: intermediateTrainingService.answerList,
            builder: (_, answerList, __) => MultipleChoiceButton(
              text: choiceList[secondIndex],
              correctAnswer: answerList[secondIndex],
              reset: intermediateTrainingService.skip,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: intermediateTrainingService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
      ],
    );
  }
}
