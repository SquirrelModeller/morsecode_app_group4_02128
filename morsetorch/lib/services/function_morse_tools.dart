import 'dart:math';
import 'dart:developer' as dev;
import 'package:english_words/english_words.dart';
import 'package:morsetorch/models/morse_state.dart';

class FunctionMorseTools {
  String convertMorseEnumToString(List<MorseState> morseCode) {
    return morseCode.map((m) => m == MorseState.Dot ? "." : "-").join();
  }

  String randomABCGen() {
    return String.fromCharCode('A'.codeUnitAt(0) + Random().nextInt(26));
  }

  String randomWordGen() {
    return WordPair.random().toString().toUpperCase();
  }

  MorseState calcMorseType(int duration, int threshold) {
    return duration <= threshold ? MorseState.Dot : MorseState.Dash;
  }
}

class HandleInput {
  Stopwatch stopwatch = Stopwatch();
  int timePressed = 0; 

  void startPress() {
    stopwatch.start();
  }

  void stopPress() {
    stopwatch.stop();
    timePressed = stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }
}
