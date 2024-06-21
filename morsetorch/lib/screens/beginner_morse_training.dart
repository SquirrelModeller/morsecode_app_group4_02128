import 'package:flutter/material.dart';
import 'package:morsetorch/services/beginner_training_service.dart';
import 'package:morsetorch/widgets/multiple_choice.dart';

class BeginnerMorseTrainingPage extends StatefulWidget {
  final Function(int) setScreen;

  const BeginnerMorseTrainingPage({super.key, required this.setScreen});

  @override
  State<BeginnerMorseTrainingPage> createState() =>
      _BeginnerMorseTrainingPageState();
}

class _BeginnerMorseTrainingPageState extends State<BeginnerMorseTrainingPage> {
  BeginnerTrainingService beginnerTrainingService = BeginnerTrainingService();
  Map<dynamic, dynamic> morseCodes = {};
  String correctLetter = '';

  List<String> choiceList = [];
  List<bool> answerList = [];

  @override
  void initState() {
    super.initState();
    morseCodes = beginnerTrainingService.get4RandomMorseCodes();
    correctLetter = beginnerTrainingService.getCorrectLetter();
    print(correctLetter);
    setAnswers();
  }

  void setAnswers() {
    setState(() {
      morseCodes.forEach((key, value) {
        choiceList.add(key);
        answerList.add(value);
        print('Key: $key, Value: $value');
      });
    });
    print(choiceList);
    print(answerList);
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
                backgroundColor: Colors.white,
                onPressed: () {
                  widget.setScreen(0);
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MultipleChoiceButton(
                        text: choiceList[0], correctAnswer: answerList[0]),
                    MultipleChoiceButton(
                        text: choiceList[1], correctAnswer: answerList[1]),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MultipleChoiceButton(
                        text: choiceList[2], correctAnswer: answerList[2]),
                    MultipleChoiceButton(
                        text: choiceList[3], correctAnswer: answerList[3]),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
