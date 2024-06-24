import 'dart:async';
import 'package:flutter/material.dart';
import 'package:morsetorch/services/timing_mastery_service.dart';
import 'package:morsetorch/widgets/costum_skip_button.dart';
import 'package:morsetorch/widgets/custom_back_button.dart';

class TimingMasteryScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(int) setScreen;

  const TimingMasteryScreen(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  _TimingMasteryScreenState createState() => _TimingMasteryScreenState();
}

class _TimingMasteryScreenState extends State<TimingMasteryScreen> {
  late TimingMasteryService timingMasteryService;
  Color buttonColor = Colors.grey;
  Timer? colorUpdateTimer;
  int pressDuration = 0;
  ValueNotifier<int> buttonDuration = ValueNotifier(300);
  GameDifficulty gameMode = GameDifficulty.normal;

  @override
  void initState() {
    super.initState();
    timingMasteryService = TimingMasteryService(gameMode);
  }

  @override
  void dispose() {
    colorUpdateTimer?.cancel();
    super.dispose();
  }

  void startPress() {
    buttonDuration.value = timingMasteryService.pressSpeed.value;
    timingMasteryService.startedPress();
    setState(() {
      buttonColor = Colors.green;
    });

    colorUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        pressDuration += 50;
        if (pressDuration > timingMasteryService.pressSpeed.value) {
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
    timingMasteryService.stoppedPress();
    colorUpdateTimer?.cancel();
    setState(() {
      buttonColor = Colors.grey;
      pressDuration = 0;
    });
  }

  void showGameModeExplanation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Mode Explanation'),
          content: const Text(
              'Selecting the difficulty lowers the accaptable threshold wherein an input is considered correct. Tap and hold the button just before it goes red.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomBackButton(
            isDarkMode: widget.isDarkMode,
            onPressed: () => widget.setScreen(0)),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<GameDifficulty>(
                    value: gameMode,
                    onChanged: (GameDifficulty? newValue) {
                      if (newValue != null) {
                        setState(() {
                          gameMode = newValue;
                          timingMasteryService = TimingMasteryService(gameMode);
                        });
                      }
                    },
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                    dropdownColor: widget.isDarkMode
                        ? const Color.fromARGB(255, 5, 20, 36)
                        : Colors.white,
                    items: GameDifficulty.values.map((GameDifficulty mode) {
                      return DropdownMenuItem<GameDifficulty>(
                        value: mode,
                        child: Text(mode.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: showGameModeExplanation,
                  ),
                ],
              ),
              ValueListenableBuilder<String>(
                valueListenable: timingMasteryService.currentCharacter,
                builder: (_, char, __) => Text(
                  char,
                  style: TextStyle(
                      fontSize: 48,
                      color: widget.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: timingMasteryService.morseCode,
                builder: (_, morse, __) {
                  final typedLength =
                      timingMasteryService.typedMorseCode.value.length;
                  final untypedMorse = morse.length > typedLength
                      ? morse.substring(typedLength)
                      : '';
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: timingMasteryService.typedMorseCode.value,
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
                  valueListenable: timingMasteryService.pressSpeed,
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
                valueListenable: timingMasteryService.result,
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
              CustomSkipButton(
                onPressed: timingMasteryService.skipCharacter,
                isDarkMode: widget.isDarkMode,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}