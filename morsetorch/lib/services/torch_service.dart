import 'dart:developer';
import 'package:torch_light/torch_light.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';

class TorchService {
  final Morsetranslator _translator = Morsetranslator();

  Future<void> sendMorseCode(String text, int delay) async {
    int dotDuration = 1 * delay;
    int dashDuration = 3 * delay;
    int elementGap = 1 * delay;
    int letterGap = 3 * delay;
    int wordGap = 7 * delay;

    var morseCode = _translator.textToMorse(text);
    if (morseCode.isEmpty) {
      print("No Morse code generated from the input.");
      return;
    }

    Stopwatch stopwatch = Stopwatch()..start();
    for (var sentence in morseCode) {
      for (var word in sentence) {
        for (var symbol in word) {
          TorchLight.enableTorch();
          int startTime = stopwatch.elapsedMilliseconds;
          await Future.delayed(Duration(
              milliseconds:
                  symbol == MorseState.Dot ? dotDuration : dashDuration));
          int endTime = stopwatch.elapsedMilliseconds;
          TorchLight.disableTorch();
          log('Symbol ${symbol == MorseState.Dot ? '.' : '-'} started at $startTime ms and ended at $endTime ms, difference: ${endTime - startTime}');
          await Future.delayed(Duration(milliseconds: elementGap));
        }
        await Future.delayed(Duration(milliseconds: letterGap - elementGap));
      }
      await Future.delayed(Duration(milliseconds: wordGap - letterGap));
    }
    stopwatch.stop();
  }
}
