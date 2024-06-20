import 'dart:async';
import 'dart:developer';
import 'package:english_words/english_words.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';
import 'package:flutter/material.dart';

class MorseTraining {
  Stopwatch stopwatch = Stopwatch();
  Timer? inputTimeout;
  Morsetranslator translator = Morsetranslator();

  ValueNotifier<String> characterTyped = ValueNotifier("");
  ValueNotifier<String> wordToType = ValueNotifier("");
  ValueNotifier<String> builder = ValueNotifier("");

  List<MorseState> builderMorseState = [];

  int timePressed = 0;
  bool isPressed = false;

  Timer? _timer; // Declare a Timer variable

  MorseTraining() {
    stopwatch.start();
    beginTraining();
  }

  void clearBuilder() {
    characterTyped.value = "";
    builderMorseState.clear();
  }

  String convertMorseStateEnumToString() {
    String tempReturn = "";
    for (var signal in builderMorseState) {
      tempReturn += signal == MorseState.Dot ? "." : "-";
    }
    return tempReturn;
  }

  void beginTraining() {
    wordToType.value = randomWordGen();
    resetBuilder();
  }

  String randomWordGen() {
    return WordPair.random().toString().toUpperCase();
  }

  void resetBuilder() {
    builder.value = "";
    builderMorseState.clear();
    resetInputTimeout();
  }

  void resetInputTimeout() {
    inputTimeout?.cancel();
    inputTimeout = Timer(const Duration(seconds: 1), () {
      log("Input timeout - resetting builder");
      resetInputTimeout();
      clearBuilder();
    });
  }

  MorseState handleMorseState(int duration) {
    return duration <= 125 ? MorseState.Dot : MorseState.Dash;
  }

  void startedPress() {
    timePressed = stopwatch.elapsedMilliseconds;
    stopwatch.start();
  }

  void checkInput() {
    int duration = stopwatch.elapsedMilliseconds - timePressed;
    log(timePressed.toString());
    log(duration.toString());
    builderMorseState.add(handleMorseState(duration));
    resetInputTimeout();
    if (builderMorseState.isNotEmpty) {
      log(builderMorseState.last.toString());
    }
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

  void release() {
    log("Released");
    isPressed = false;
    checkInput();
    String localAttempt = getText();
    _timer?.cancel();
    characterTyped.value = localAttempt;
    _timer = Timer(Duration(seconds: 1), () {
      if (isCorrect(builder.value + localAttempt)) {
        builder.value += localAttempt;
        log("Current builder state: ${builder.value}");
        clearBuilder();
        if (won()) {
          // Win condition
          clearBuilder();
          resetBuilder();
          wordToType.value = randomWordGen();
        }
      }
    });
  }

  bool isCorrect(String sentenceToCheck) {
    return wordToType.value.startsWith(sentenceToCheck);
  }

  bool won() {
    return builder.value == wordToType.value;
  }

  void dispose() {
    stopwatch.stop();
    inputTimeout?.cancel();
  }
}
