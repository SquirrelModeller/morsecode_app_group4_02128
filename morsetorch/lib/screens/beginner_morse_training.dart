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

class _MultipleChoiceButtonState extends State<MultipleChoiceButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        onPressed: () {
          if (widget.correctAnswer) {
            // Handle correct answer
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Correct!'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            // Handle incorrect answer
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incorrect!'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}

class _BeginnerMorseTrainingPageState extends State<BeginnerMorseTrainingPage> {
  BeginnerTrainingService beginnerTrainingService = BeginnerTrainingService();
  List<String> choiceList = [];
  List<bool> answerList = [];
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

  void increaseStreak(bool correct) {
    if (correct == true) {
      streak += 1;
    } else {
      streak = 0;
    }
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
                        'Guess the character $letter',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 118, 118, 118)))),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder<List<String>>(
                      valueListenable: beginnerTrainingService.choiceList,
                      builder: (_, choiceList, __) =>
                          ValueListenableBuilder<List<bool>>(
                        valueListenable: beginnerTrainingService.answerList,
                        builder: (_, answerList, __) => MultipleChoiceButton(
                          text: choiceList[
                              0], // Access the list from the builder parameter
                          correctAnswer: answerList[
                              0], // Access the list from the inner builder parameter
                          whenPressed: () {
                            setUpGame();
                            disableButtonTemporarily();
                          },
                          isEnabled: isButtonEnabled,
                          streak: increaseStreak,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<List<String>>(
                      valueListenable: beginnerTrainingService.choiceList,
                      builder: (_, choiceList, __) =>
                          ValueListenableBuilder<List<bool>>(
                        valueListenable: beginnerTrainingService.answerList,
                        builder: (_, answerList, __) => MultipleChoiceButton(
                          text: choiceList[
                              1], // Access the list from the builder parameter
                          correctAnswer: answerList[
                              1], // Access the list from the inner builder parameter
                          whenPressed: () {
                            setUpGame();
                            disableButtonTemporarily();
                          },
                          isEnabled: isButtonEnabled,
                          streak: increaseStreak,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder<List<String>>(
                      valueListenable: beginnerTrainingService.choiceList,
                      builder: (_, choiceList, __) =>
                          ValueListenableBuilder<List<bool>>(
                        valueListenable: beginnerTrainingService.answerList,
                        builder: (_, answerList, __) => MultipleChoiceButton(
                          text: choiceList[
                              2], // Access the list from the builder parameter
                          correctAnswer: answerList[
                              2], // Access the list from the inner builder parameter
                          whenPressed: () {
                            setUpGame();
                            disableButtonTemporarily();
                          },
                          isEnabled: isButtonEnabled,
                          streak: increaseStreak,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<List<String>>(
                      valueListenable: beginnerTrainingService.choiceList,
                      builder: (_, choiceList, __) =>
                          ValueListenableBuilder<List<bool>>(
                        valueListenable: beginnerTrainingService.answerList,
                        builder: (_, answerList, __) => MultipleChoiceButton(
                          text: choiceList[
                              3], // Access the list from the builder parameter
                          correctAnswer: answerList[
                              3], // Access the list from the inner builder parameter
                          whenPressed: () {
                            setUpGame();
                            disableButtonTemporarily();
                          },
                          isEnabled: isButtonEnabled,
                          streak: increaseStreak,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                FloatingActionButton(
                  onPressed: () {
                    increaseStreak(false);
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
