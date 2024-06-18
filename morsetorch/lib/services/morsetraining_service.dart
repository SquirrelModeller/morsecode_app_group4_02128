import 'dart:async';
import 'package:english_words/english_words.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';

class MorseTraining {
  int lastTime = 0;
  String wordToType = "";
  String builder = "";
  List<MorseState> builderMorseState = [];
  Stopwatch stopwatch = Stopwatch();
  Timer? inputTimeout;

  Morsetranslator translator = Morsetranslator();

  MorseTraining() {
    stopwatch.start();
  }

  String randomWordGen() {
    return WordPair.random().toString().toUpperCase();
  }

  void beginTraining() {
    wordToType = randomWordGen();
    resetBuilder();
  }

  void resetBuilder() {
    builder = "";
    builderMorseState.clear();
    resetInputTimeout();
  }

  void resetInputTimeout() {
    inputTimeout?.cancel();
    inputTimeout = Timer(Duration(seconds: 5), () {
      print("Input timeout - resetting builder");
      resetBuilder();
    });
  }

  MorseState handleMorseState(int duration) {
    return duration <= 150 ? MorseState.Dot : MorseState.Dash;
  }

  void startedPress() {
    lastTime = stopwatch.elapsedMilliseconds;
  }

  void checkInput() {
    int currentTime = stopwatch.elapsedMilliseconds;
    int duration = currentTime - lastTime;
    if (duration > 200) {
      print("Took too long between presses");
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
      print("Translation error: ${e}");
      return "";
    }
  }

  void release() {
    checkInput();
    String localAttempt = getText();
    if (isCorrect(builder + localAttempt)) {
      builder += localAttempt;
      print("Current builder state: $builder");
    }
  }

  bool isCorrect(String sentenceToCheck) {
    return wordToType.startsWith(sentenceToCheck);
  }

  void dispose() {
    stopwatch.stop();
    inputTimeout?.cancel();
  }
}
