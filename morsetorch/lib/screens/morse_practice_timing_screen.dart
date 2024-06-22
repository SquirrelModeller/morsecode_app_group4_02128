import 'dart:async';
import 'package:flutter/material.dart';
import 'package:morsetorch/services/morse_practice_timing.dart';
import 'package:morsetorch/widgets/custom_floating_action_button.dart';

class MorsePracticeTimingScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(int) setScreen;

  const MorsePracticeTimingScreen(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  _MorsePracticeTimingState createState() => _MorsePracticeTimingState();
}

class _MorsePracticeTimingState extends State<MorsePracticeTimingScreen> {
  late MorsePracticeTiming morsePracticeTiming;
  Color buttonColor = Colors.grey;
  Timer? colorUpdateTimer;
  int pressDuration = 0;
  ValueNotifier<int> buttonDuration = ValueNotifier(300);

  @override
  void initState() {
    super.initState();
    morsePracticeTiming = MorsePracticeTiming(GameMode.normal);
  }

  @override
  void dispose() {
    colorUpdateTimer?.cancel();
    super.dispose();
  }

  void startPress() {
    buttonDuration.value = morsePracticeTiming.pressSpeed.value;
    morsePracticeTiming.startedPress();
    setState(() {
      buttonColor = Colors.green;
    });

    morsePracticeTiming.result.addListener(() {
      if (morsePracticeTiming.result.value == MorseChallengeResult.tooSoon ||
          morsePracticeTiming.result.value == MorseChallengeResult.tooLate) {
        buttonDuration.value = 0;
      }
    });

    colorUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        pressDuration += 50;
        if (pressDuration > morsePracticeTiming.pressSpeed.value) {
          buttonDuration.value = 0;
          buttonColor = Colors.red;
        } else {
          buttonColor = Colors.green;
        }
      });
    });
  }

  void endPress() {
    buttonDuration.value = 0;
    morsePracticeTiming.stoppedPress();
    colorUpdateTimer?.cancel();
    setState(() {
      buttonColor = Colors.grey;
      pressDuration = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Stack(children: [
        CustomFloatingActionButton(isDarkMode: widget.isDarkMode, onPressed: () => widget.setScreen(0)),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: morsePracticeTiming.currentCharacter,
                builder: (_, char, __) => Text(
                  char,
                  style: TextStyle(
                      fontSize: 48,
                      color: widget.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: morsePracticeTiming.morseCode,
                builder: (_, morse, __) {
                  final typedLength =
                      morsePracticeTiming.typedMorseCode.value.length;
                  final untypedMorse = morse.substring(typedLength);
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: morsePracticeTiming.typedMorseCode.value,
                          style: TextStyle(
                            fontSize: 48,
                            color:
                                widget.isDarkMode ? Colors.blue : Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: untypedMorse,
                          style: TextStyle(
                            fontSize: 48,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              GestureDetector(
                onTapDown: (_) => startPress(),
                onTapUp: (_) => endPress(),
                onTapCancel: () => endPress(),
                child: ValueListenableBuilder<int>(
                  valueListenable: morsePracticeTiming.pressSpeed,
                  builder: (_, duration, __) => AnimatedContainer(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(75),
                    ),
                    duration: Duration(milliseconds: buttonDuration.value),
                    curve: Curves.fastOutSlowIn,
                    child: const Icon(Icons.radio_button_unchecked,
                        size: 100, color: Colors.white),
                  ),
                ),
              ),
              ValueListenableBuilder<MorseChallengeResult>(
                valueListenable: morsePracticeTiming.result,
                builder: (_, result, __) {
                  String resultStr = "";

                  switch (result) {
                    case MorseChallengeResult.pass:
                      resultStr = "";
                      break;
                    case MorseChallengeResult.tooLate:
                      resultStr = "Too Late";
                      break;
                    case MorseChallengeResult.tooSoon:
                      resultStr = "Too Soon";
                      break;
                    case MorseChallengeResult.inProgress:
                      resultStr = "";
                      break;
                    case MorseChallengeResult.won:
                      resultStr = "";
                      break;
                  }
                  return Text(
                    resultStr,
                    style: TextStyle(
                      fontSize: 48,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
