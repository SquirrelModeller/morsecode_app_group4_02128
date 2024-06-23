import 'dart:async';
import 'dart:developer';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';
import 'package:flutter/material.dart';
import 'package:morsetorch/services/function_morse_tools.dart';

enum MorseChallengeResult { pass, inProgress }

class MorseTraining {
  ValueNotifier<MorseChallengeResult> result =
      ValueNotifier(MorseChallengeResult.inProgress);

  FunctionMorseTools tools = FunctionMorseTools();
  HandleInput inputHandler = HandleInput();

  Stopwatch stopwatch = Stopwatch();
  Timer? inputTimeout;
  Morsetranslator translator = Morsetranslator();

  ValueNotifier<String> characterTyped = ValueNotifier("");
  ValueNotifier<String> wordToType = ValueNotifier("");
  ValueNotifier<String> builder = ValueNotifier("");
  ValueNotifier<String> typedMorseCode = ValueNotifier('');

  List<MorseState> builderMorseState = [];

  int timePressed = 0;
  bool isPressed = false;

  Timer? _timer; // Declare a Timer variable

  MorseTraining() {
    stopwatch.start();
    beginTraining();
  }

  void beginTraining() {
    wordToType.value = tools.randomWordGen();
    resetBuilder();
  }

  void resetBuilder() {
    result.value = MorseChallengeResult.inProgress;
    builder.value = "";
    typedMorseCode.value = '';
    builderMorseState.clear();
    resetInputTimeout();
  }

  void clearBuilder() {
    characterTyped.value = "";
    typedMorseCode.value = '';
    builderMorseState.clear();
  }

  void resetInputTimeout() {
    inputTimeout?.cancel();
    inputTimeout = Timer(const Duration(seconds: 1), () {
      log("Input timeout - resetting builder");
      resetInputTimeout();
      clearBuilder();
    });
  }

  void checkInput(duration) {
    log(inputHandler.timePressed.toString());
    log(duration.toString());
    builderMorseState.add(tools.calcMorseType(duration, 125));
    resetInputTimeout();
    if (builderMorseState.isNotEmpty) {
      log(builderMorseState.last.toString());
    }
  }

  bool isCorrect(String sentenceToCheck) {
    return wordToType.value.startsWith(sentenceToCheck);
  }

  bool won() {
    return builder.value == wordToType.value;
  }

  String getText() {
    try {
      log(translator.morseToText(builderMorseState));
      return translator.morseToText(builderMorseState);
    } on Exception catch (e) {
      log("Translation error: $e");
      clearBuilder();
      return "";
    }
  }

  void startedPress() {
    inputHandler.startPress();
  }

  void release() {
    log("Released");
    isPressed = false;
    inputHandler.stopPress();

    checkInput(inputHandler.timePressed);
    String localAttempt = getText();
    _timer?.cancel();
    characterTyped.value = localAttempt;
    typedMorseCode.value = tools.convertMorseEnumToString(builderMorseState);

    _timer = Timer(const Duration(seconds: 1), () {
      if (isCorrect(builder.value + localAttempt)) {
        builder.value += localAttempt;
        log("Current builder state: ${builder.value}");
        clearBuilder();
        if (won()) {
          result.value = MorseChallengeResult.pass;
          _timer = Timer(const Duration(seconds: 1), () {
            clearBuilder();
            resetBuilder();
            wordToType.value = tools.randomWordGen();
          });
        }
      }
    });
  }

  void dispose() {
    stopwatch.stop();
    inputTimeout?.cancel();
  }
}
