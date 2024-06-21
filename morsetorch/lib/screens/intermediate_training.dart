import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/intermediate_training_service.dart';
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
  IntermediateTrainingService mediumTraining = IntermediateTrainingService();
  var answers = {};
  var choiceList = [];
  var answerList = [];
  bool isButtonEnabled = true;
  var streak = 0;

  @override
  void initState() {
    super.initState();
    mediumTraining.initFourRandomLetters();
    answers = mediumTraining.morseResult;
    setAnswers();
  }

  void reset() {
    mediumTraining.resetAnswers();
    choiceList = [];
    answerList = [];
  }

  void skip() {
    reset();
    mediumTraining.initFourRandomLetters();
    answers = mediumTraining.morseResult;
    print(answers);
    print(streak);
    setAnswers();
  }

  void setAnswers() {
    setState(() {
      answers.forEach((key, value) {
        choiceList.add(key);
        answerList.add(value);
      });
    });
  }

  void vibrate() {
    var morseCode = mediumTraining.correctMorseCode;
    var vibration = mediumTraining.getVibration(morseCode);
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

  void increaseStreak(bool correct) {
    if (correct == true) {
      streak += 1;
    } else {
      streak = 0;
    }
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MultipleChoiceButton(
                            text: choiceList[0],
                            correctAnswer: answerList[0],
                            whenPressed: () {
                              skip();
                              disableButtonTemporarily();
                            },
                            isEnabled: isButtonEnabled,
                            streak: increaseStreak,
                          ),
                          MultipleChoiceButton(
                            text: choiceList[1],
                            correctAnswer: answerList[1],
                            whenPressed: () {
                              skip();
                              disableButtonTemporarily();
                            },
                            isEnabled: isButtonEnabled,
                            streak: increaseStreak,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MultipleChoiceButton(
                            text: choiceList[2],
                            correctAnswer: answerList[2],
                            whenPressed: () {
                              skip();
                              disableButtonTemporarily();
                            },
                            isEnabled: isButtonEnabled,
                            streak: increaseStreak,
                          ),
                          MultipleChoiceButton(
                            text: choiceList[3],
                            correctAnswer: answerList[3],
                            whenPressed: () {
                              skip();
                              disableButtonTemporarily();
                            },
                            isEnabled: isButtonEnabled,
                            streak: increaseStreak,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
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
                    increaseStreak(false);
                    skip();
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
                Text("Streak: $streak", style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
