import 'dart:math';
import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';

class BeginnerTrainingService {
  //String correctLetter = "";
  ValueNotifier<String> correctLetter = ValueNotifier("");
  ValueNotifier<List<String>> choiceList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<bool>> answerList = ValueNotifier<List<bool>>([]);

  setUpGame() {
    resetGame();
    get4RandomMorseCodes().forEach((key, value) {
      choiceList.value.add(key);
      answerList.value.add(value);
    });
  }
  
  void resetGame() {
    choiceList.value.clear();
    answerList.value.clear();
  }

  Map get4RandomMorseCodes() {
    List<String> validCharacters = List.generate(
            26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index)) +
        List.generate(10, (index) => index.toString());
    validCharacters.shuffle(Random());
    var characters = validCharacters.sublist(0, 4);

    List<List<MorseState>> enums = [];
    for (String c in characters) {
      if (morseCode.containsKey(c)) {
        enums.add(morseCode[c]!);
      }
    }

    List<String> allLetters = [];
    for (List<MorseState> i in enums) {
      String letter = "";
      for (MorseState j in i) {
        if (j == MorseState.Dot) {
          letter += "·";
        } else if (j == MorseState.Dash) {
          letter += "−";
        }
      }
      allLetters.add(letter);
    }

    Random random = Random();
    int randomNumber = random.nextInt(4);
    Map<String, bool> morseResult = {};

    for (int i = 0; i < 4; i++) {
      if (i == randomNumber) {
        morseResult[allLetters[i]] = true;
      } else {
        morseResult[allLetters[i]] = false;
      }
    }
    correctLetter.value = characters[randomNumber];
    return morseResult;
  }

  String getCorrectLetter() {
    return correctLetter.value;
  }
}
