import 'package:flutter/material.dart';
import 'package:morsetorch/services/buzz_code_service.dart';
import 'package:morsetorch/widgets/costum_skip_button.dart';
import 'package:morsetorch/widgets/custom_back_button.dart';
import 'package:morsetorch/widgets/custom_multiple_choice_button.dart';
import 'package:vibration/vibration.dart';

class BuzzCodeScreen extends StatefulWidget {
  final Function(int) setScreen;
  final bool isDarkMode;

  const BuzzCodeScreen(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  State<BuzzCodeScreen> createState() => _BuzzCodeScreenState();
}

class _BuzzCodeScreenState extends State<BuzzCodeScreen> {
  BuzzCodeService buzzCodeService = BuzzCodeService();

  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    buzzCodeService.setUpGame();
  }

  void vibrate() {
    var morseCode = buzzCodeService.correctMorseCode;
    var vibration = buzzCodeService.getVibration(morseCode);
    Vibration.vibrate(
      pattern: vibration,
    );
  }

  void disableButtonTemporarily() {
    setState(() {
      isButtonEnabled = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
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
                    if (isButtonEnabled) {
                      vibrate();
                    }
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
                CustomSkipButton(
                  onPressed: () {
                    buzzCodeService.increaseStreak(false);
                    buzzCodeService.skip();
                  },
                  isDarkMode: widget.isDarkMode,
                ),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: buzzCodeService.streak,
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
          valueListenable: buzzCodeService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: buzzCodeService.answerList,
            builder: (_, answerList, __) => CustomMultipleChoiceButton(
              text: choiceList[firstIndex],
              correctAnswer: answerList[firstIndex],
              reset: buzzCodeService.skip,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: buzzCodeService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: buzzCodeService.choiceList,
          builder: (_, choiceList, __) => ValueListenableBuilder<List<bool>>(
            valueListenable: buzzCodeService.answerList,
            builder: (_, answerList, __) => CustomMultipleChoiceButton(
              text: choiceList[secondIndex],
              correctAnswer: answerList[secondIndex],
              reset: buzzCodeService.skip,
              disableButton: disableButtonTemporarily,
              isEnabled: isButtonEnabled,
              streak: buzzCodeService.increaseStreak,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        ),
      ],
    );
  }
}
