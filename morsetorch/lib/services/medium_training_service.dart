import 'dart:math';
import 'package:morsetorch/models/morse_state.dart';

class MediumTrainingService {
  List<MorseState> _correctMorseCode = [];

  List<String> getRandomCharacters() {
    List<String> validCharacters = List.generate(
            26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index)) +
        List.generate(10, (index) => index.toString());
    validCharacters.shuffle(Random());
    var characters = validCharacters.sublist(0, 4);
    return characters;
  }

  int getRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(4);
    return randomNumber;
  }

  void initFourRandomLetters() {
    Map<String, bool> morseResult = {};
    var characters = getRandomCharacters();
    int randomNumber = getRandomNumber();
    var correctChar = characters[randomNumber];

    for (String c in characters) {
      if (c == correctChar) {
        morseResult[c] = true;
        if (morseCode.containsKey(c)) {
          _correctMorseCode = morseCode[c]!;
        }
      } else {
        morseResult[c] = false;
      }
    }
  }

  List<MorseState> get correctMorseCode => _correctMorseCode;
}
