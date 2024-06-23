import 'dart:math';
import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';

class MorseMatchService {
  ValueNotifier<String> correctLetter = ValueNotifier("");
  ValueNotifier<List<String>> choiceList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<bool>> answerList = ValueNotifier<List<bool>>([]);
  ValueNotifier<int> streak = ValueNotifier(0);

  List<String> validCharacters = List.generate(
          26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index)) +
      List.generate(10, (index) => index.toString());

  setUpGame() {
    resetGame();
    var morseResult = get4RandomMorseCodes();
    choiceList.value = morseResult.keys.toList();
    answerList.value = morseResult.values.toList();
  }

  void resetGame() {
    choiceList.value = [];
    answerList.value = [];
  }

  void increaseStreak(bool correct) {
    if (correct) {
      streak.value += 1;
    } else {
      streak.value = 0;
    }
  }

  Map<String, bool> get4RandomMorseCodes() {
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
      morseResult[allLetters[i]] = i == randomNumber;
    }

    correctLetter.value = characters[randomNumber];
    return morseResult;
  }
}
