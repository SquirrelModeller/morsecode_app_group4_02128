import 'dart:math';
import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';

class BuzzCodeService {
  List<MorseState> _correctMorseCode = [];
  Map<String, bool> _morseResult = {};
  List<String> getRandomCharacters() {
    List<String> validCharacters = List.generate(
            26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index)) +
        List.generate(10, (index) => index.toString());
    validCharacters.shuffle(Random());
    var characters = validCharacters.sublist(0, 4);
    return characters;
  }

  ValueNotifier<List<String>> choiceList = ValueNotifier<List<String>>([]);
  ValueNotifier<List<bool>> answerList = ValueNotifier<List<bool>>([]);
  ValueNotifier<int> streak = ValueNotifier(0);

  void setUptGame() {
    initFourRandomLetters();
    setAnswers();
  }

  void setAnswers() {
    _morseResult.forEach((key, value) {
      choiceList.value.add(key);
      answerList.value.add(value);
    });
  }

  void reset() {
    resetAnswers();
    choiceList.value = [];
    answerList.value = [];
  }

  void resetAnswers() {
    _correctMorseCode = [];
    _morseResult = {};
  }

  void skip() {
    reset();
    initFourRandomLetters();
    setAnswers();
  }

  void increaseStreak(bool correct) {
    if (correct) {
      streak.value += 1;
    } else {
      streak.value = 0;
    }
  }

  int getRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(4);
    return randomNumber;
  }

  void initFourRandomLetters() {
    var characters = getRandomCharacters();
    int randomNumber = getRandomNumber();
    var correctChar = characters[randomNumber];

    for (String c in characters) {
      if (c == correctChar) {
        _morseResult[c] = true;
        if (morseCode.containsKey(c)) {
          _correctMorseCode = morseCode[c]!;
        }
      } else {
        _morseResult[c] = false;
      }
    }
  }

  List<int> getVibration(List<MorseState> morseCode) {
    List<int> vibration = [];
    for (var c in morseCode) {
      vibration.add(130);
      if (c == MorseState.Dot) {
        vibration.add(130);
      } else {
        vibration.add(390);
      }
    }
    return vibration;
  }

  List<MorseState> get correctMorseCode => _correctMorseCode;

  Map<String, bool> get morseResult => _morseResult;
}
