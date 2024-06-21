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
    return Container(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        onPressed: () {
          if (widget.correctAnswer) {
            // Handle correct answer
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Correct!'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            // Handle incorrect answer
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Incorrect!'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}

class _BeginnerMorseTrainingPageState extends State<BeginnerMorseTrainingPage> {
  BeginnerTrainingService beginnerTrainingService = BeginnerTrainingService();
  Map<dynamic, dynamic> morseCodes = {};
  String correctLetter = '';

  List<String> choiceList = [];
  List<bool> answerList = [];
  int streak = 0;

  @override
  void initState() {
    super.initState();
    setUpGame();
  }

  void setUpGame() {
    morseCodes = beginnerTrainingService.get4RandomMorseCodes();
    correctLetter = beginnerTrainingService.getCorrectLetter();
    setAnswers();
  }

  void setAnswers() {
    setState(() {
      morseCodes.forEach((key, value) {
        choiceList.add(key);
        answerList.add(value);
      });
    });
  }

  void reset() {
    choiceList.clear();
    answerList.clear();
    setUpGame();
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
                    ? Color.fromARGB(255, 5, 20, 36)
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
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MultipleChoiceButton(
                        text: choiceList[0],
                        correctAnswer: answerList[0],
                        whenPressed: reset,
                        streak: increaseStreak),
                    MultipleChoiceButton(
                        text: choiceList[1],
                        correctAnswer: answerList[1],
                        whenPressed: reset,
                        streak: increaseStreak),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MultipleChoiceButton(
                        text: choiceList[2],
                        correctAnswer: answerList[2],
                        whenPressed: reset,
                        streak: increaseStreak),
                    MultipleChoiceButton(
                        text: choiceList[3],
                        correctAnswer: answerList[3],
                        whenPressed: reset,
                        streak: increaseStreak),
                  ],
                ),
                SizedBox(height: 30),
                FloatingActionButton(
                  onPressed: () {
                    reset();
                  },
                  child: const Icon(Icons.skip_next),
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
