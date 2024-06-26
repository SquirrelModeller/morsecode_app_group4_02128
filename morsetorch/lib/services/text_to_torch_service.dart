import 'dart:developer';
import 'package:torch_light/torch_light.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';

class TextToTorchService {
  final Morsetranslator _translator = Morsetranslator();
  bool _isSendingMorse = false;

  Future<void> sendMorseCode(
      String text, int delay, Function updateIndex) async {
    _isSendingMorse = true;

    int dotDuration = 1 * delay;
    int dashDuration = 3 * delay;
    int elementGap = 1 * delay;
    int letterGap = 3 * delay;
    int wordGap = 7 * delay;

    var morseCode = _translator.textToMorse(text);
    if (morseCode.isEmpty) {
      _isSendingMorse = false;
      return;
    }

    Stopwatch stopwatch = Stopwatch()..start();
    int currentIndex = -1;
    for (var sentence in morseCode) {
      updateIndex(currentIndex);
      currentIndex++;
      for (var word in sentence) {
        updateIndex(currentIndex);
        currentIndex++;
        for (var symbol in word) {
          if (!_isSendingMorse) return;
          TorchLight.enableTorch();
          int startTime = stopwatch.elapsedMilliseconds;
          await Future.delayed(
            Duration(
                milliseconds:
                    symbol == MorseState.Dot ? dotDuration : dashDuration),
          );
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
    _isSendingMorse = false;
  }

  void stopMorseCodeSending() {
    _isSendingMorse = false;
  }
}
