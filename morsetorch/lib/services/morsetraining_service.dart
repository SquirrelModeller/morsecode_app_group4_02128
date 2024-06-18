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
    inputTimeout = Timer(Duration(seconds: 5), () {
      log("Input timeout - resetting builder");
      resetBuilder();
    });
  }

  MorseState handleMorseState(int duration) {
    return duration <= 150 ? MorseState.Dot : MorseState.Dash;
  }

  void startedPress() {
    stopwatch.start();
  }

  void checkInput() {
    int currentTime = stopwatch.elapsedMilliseconds;
    int duration = currentTime - stopwatch.elapsedMilliseconds;
    if (duration > 200) {
      log("Took too long between presses");
      resetBuilder();
      return;
    }
    builderMorseState.add(handleMorseState(duration));
    resetInputTimeout();
  }

  String getText() {
    try {
      return translator.morseToText(builderMorseState);
    } on Exception catch (e) {
      log("Translation error: ${e}");
      return "";
    }
  }

  void release() {
    checkInput();
    String localAttempt = getText();
    if (isCorrect(builder.value + localAttempt)) {
      builder.value += localAttempt;
      log("Current builder state: ${builder.value}");
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
