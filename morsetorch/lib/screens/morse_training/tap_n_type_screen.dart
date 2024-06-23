import 'package:flutter/material.dart';
import 'package:morsetorch/services/tap_n_type_service.dart';
import 'package:morsetorch/widgets/costum_skip_button.dart';
import 'package:morsetorch/widgets/costum_snack_bar.dart';
import 'package:morsetorch/widgets/custom_back_button.dart';
import 'package:morsetorch/services/function_morse_tools.dart';

class TapNTypeScreen extends StatefulWidget {
  final Function setScreen;
  final bool isDarkMode;

  const TapNTypeScreen({
    super.key,
    required this.setScreen,
    required this.isDarkMode,
  });

  @override
  _TapNTypeScreenState createState() => _TapNTypeScreenState();
}

class _TapNTypeScreenState extends State<TapNTypeScreen> {
  final TapNTypeService tapNTypeService = TapNTypeService();
  final FunctionMorseTools tools = FunctionMorseTools();
  final CostumSnackBar costumSnackBar = CostumSnackBar();

  Color colorLight = const Color.fromARGB(255, 0, 178, 255);
  Color colorDark = const Color.fromRGBO(5, 94, 132, 1);

  @override
  void initState() {
    super.initState();
    tapNTypeService.beginTraining();
  }

  @override
  void dispose() {
    tapNTypeService.dispose();
    super.dispose();
  }

  void handlePress(bool isPressed) {
    if (isPressed) {
      tapNTypeService.startedPress();
      setState(() {
        colorLight = const Color.fromARGB(255, 112, 112, 112);
        colorDark = const Color.fromARGB(255, 76, 76, 76);
      });
    } else {
      tapNTypeService.release();
      setState(() {
        colorLight = const Color.fromARGB(255, 0, 178, 255);
        colorDark = const Color.fromRGBO(5, 94, 132, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackButton(
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
                valueListenable: tapNTypeService.wordToType,
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
                    valueListenable: tapNTypeService.characterTyped,
                    builder: (_, typed, __) {
                      return ValueListenableBuilder<String>(
                        valueListenable: tapNTypeService.builder,
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
                  valueListenable: tapNTypeService.characterTyped,
                  builder: (_, typed, __) => Text(
                    tapNTypeService.typedMorseCode.value,
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
                    color: widget.isDarkMode ? colorDark : colorLight,
                  ),
                  child: const Center(
                    child: Icon(Icons.radio_button_unchecked,
                        size: 100, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomSkipButton(
                onPressed: tapNTypeService.beginTraining,
                isDarkMode: widget.isDarkMode,
              ),
              ValueListenableBuilder<MorseChallengeResult>(
                valueListenable: tapNTypeService.result,
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
