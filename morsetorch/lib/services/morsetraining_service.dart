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

  ValueNotifier<String> wordToType = ValueNotifier("");
  ValueNotifier<String> builder = ValueNotifier("");

  List<MorseState> builderMorseState = [];

  int timePressed = 0;

  MorseTraining() {
    stopwatch.start();
    beginTraining();
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
    inputTimeout = Timer(const Duration(seconds: 5), () {
      log("Input timeout - resetting builder");
      resetInputTimeout();
    });
  }

  MorseState handleMorseState(int duration) {
    return duration <= 150 ? MorseState.Dot : MorseState.Dash;
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
      builderMorseState.clear();
      return "";
    }
  }

  void release() {
    log("Released");
    checkInput();
    String localAttempt = getText();
    if (isCorrect(builder.value + localAttempt)) {
      builder.value += localAttempt;
      log("Current builder state: ${builder.value}");
      builderMorseState.clear();
    }
  }

  bool isCorrect(String sentenceToCheck) {
    return wordToType.value.startsWith(sentenceToCheck);
  }

  void dispose() {
    stopwatch.stop();
    inputTimeout?.cancel();
  }
}
