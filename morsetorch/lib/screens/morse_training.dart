import 'package:flutter/material.dart';
import 'package:morsetorch/services/morsetraining_service.dart';
import 'package:morsetorch/widgets/costum_skip_button.dart';
import 'package:morsetorch/widgets/costum_snack_bar.dart';
import 'package:morsetorch/widgets/custom_floating_action_button.dart';
import 'package:morsetorch/services/function_morse_tools.dart';

class MorseTrainingPage extends StatefulWidget {
  final Function setScreen;
  final bool isDarkMode;

  MorseTrainingPage({
    Key? key,
    required this.setScreen,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _MorseTrainingPageState createState() => _MorseTrainingPageState();
}

class _MorseTrainingPageState extends State<MorseTrainingPage> {
  final MorseTraining _morseTraining = MorseTraining();
  final FunctionMorseTools tools = FunctionMorseTools();
  final CostumSnackBar costumSnackBar = CostumSnackBar();

  Color colorLight = Color.fromARGB(255, 0, 178, 255);
  Color colorDark =  Color.fromRGBO(5, 94, 132, 1);

  @override
  void initState() {
    super.initState();
    _morseTraining.beginTraining();
  }

  @override
  void dispose() {
    _morseTraining.dispose();
    super.dispose();
  }

  void handlePress(bool isPressed) {
    if (isPressed) {
      _morseTraining.startedPress();
      setState(() {
        colorLight = const Color.fromARGB(255, 112, 112, 112);
        colorDark = Color.fromARGB(255, 76, 76, 76);
      });
    } else {
      _morseTraining.release();
      setState(() {
        colorLight = Color.fromARGB(255, 0, 178, 255);
        colorDark =  Color.fromRGBO(5, 94, 132, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomFloatingActionButton(
            isDarkMode: widget.isDarkMode,
            onPressed: () => widget.setScreen(0)),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              ValueListenableBuilder<String>(
                valueListenable: _morseTraining.wordToType,
                builder: (_, word, __) => Text(
                  'Word to type: $word',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ValueListenableBuilder<String>(
                    valueListenable: _morseTraining.characterTyped,
                    builder: (_, typed, __) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _morseTraining.builder,
                        builder: (_, typedString, __) => Text(
                          'Current Input: $typedString $typed',
                          style: TextStyle(
                            fontSize: 20,
                            color: widget.isDarkMode
                                ? const Color.fromRGBO(5, 94, 132, 1)
                                : const Color.fromRGBO(0, 178, 255, 1),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: ValueListenableBuilder<String>(
                  valueListenable: _morseTraining.characterTyped,
                  builder: (_, typed, __) => Text(
                    '${_morseTraining.typedMorseCode.value}',
                    style: TextStyle(
                      fontSize: 100,
                      color: widget.isDarkMode
                          ? const Color.fromRGBO(5, 94, 132, 1)
                          : const Color.fromRGBO(0, 178, 255, 1),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => handlePress(true),
                onTapUp: (_) => handlePress(false),
                onTapCancel: () => handlePress(false),
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isDarkMode
                        ? colorDark
                        : colorLight,
                  ),
                  child: const Center(
                    child: Icon(Icons.radio_button_unchecked,
                        size: 100, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomSkipButton(
                onPressed: _morseTraining.beginTraining,
                isDarkMode: widget.isDarkMode,
              ),
              ValueListenableBuilder<MorseChallengeResult>(
                valueListenable: _morseTraining.result,
                builder: (_, result, __) {
                  String resultStr = "";
                  switch (result) {
                    case MorseChallengeResult.pass:
                      resultStr = "Good job!";
                      costumSnackBar.showSnackBar(resultStr, context);
                      break;
                    case MorseChallengeResult.inProgress:
                      resultStr = "";
                      break;
                  }
                  return Container(); // Return an empty container instead of text
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
