import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/function_morse_tools.dart';
import 'package:morsetorch/services/morse_translator.dart';

enum MorseChallengeResult { pass, tooLate, tooSoon, inProgress, won }

enum GameMode { easy, normal, hard }

class MorsePracticeTiming {
  ValueNotifier<MorseChallengeResult> result = ValueNotifier(MorseChallengeResult.inProgress);
  ValueNotifier<String> currentCharacter = ValueNotifier('');
  ValueNotifier<String> morseCode = ValueNotifier('');
  ValueNotifier<String> typedMorseCode = ValueNotifier('');
  ValueNotifier<int> pressSpeed = ValueNotifier(300);
  ValueNotifier<int> timePressed = ValueNotifier(0);
  ValueNotifier<Map<String, int>> completedCharacters = ValueNotifier({});

  FunctionMorseTools tools = FunctionMorseTools();
  HandleInput inputHandler = HandleInput();
  List<MorseState> expectedMorseSequence = [];
  List<MorseState> inputMorseSequence = [];
  int currentSymbolIndex = 0;


  int threshHold = 0;

  MorsePracticeTiming(GameMode mode) {
    switch (mode) {
      case GameMode.easy:
        threshHold = 160;
        break;
      case GameMode.normal:
        threshHold = 80;
        break;
      case GameMode.hard:
        threshHold = 30;
        break;
    }
    nextCharacter();
  }

  void resetRound() {
    typedMorseCode.value = '';
    currentSymbolIndex = 0;
    inputMorseSequence = [];
  }

  void nextCharacter() {
    currentCharacter.value = tools.randomABCGen();
    var rawMorse = Morsetranslator().textToMorse(currentCharacter.value);
    List<MorseState> morse = [];
    for (var sentence in rawMorse) {
      for (var word in sentence) {
        morse = word;
      }
    }
    expectedMorseSequence = morse;
    morseCode.value = tools.convertMorseEnumToString(morse);
    resetRound();
  }

  void updatePressedSpeed() {
    if (expectedMorseSequence == []) {
      return;
    }
    pressSpeed.value = expectedMorseSequence[currentSymbolIndex] == MorseState.Dot ? 100 : 300;
  }

  void startedPress() {
    updatePressedSpeed();
    inputHandler.startPress();
  }

  void stoppedPress() {
    inputHandler.stopPress();
    evaluateInput();
  }

  void evaluateInput() {
    int duration = inputHandler.timePressed;
    timePressed.value = duration;
    updatePressedSpeed();

    MorseState inputMorse;

    if (pressSpeed.value-threshHold > duration) {
      result.value = MorseChallengeResult.tooSoon;
      return;
    }
    if (pressSpeed.value+threshHold < duration) {
      result.value = MorseChallengeResult.tooLate;
      return;
    }
    result.value = MorseChallengeResult.pass;

    inputMorse = expectedMorseSequence[currentSymbolIndex];

    inputMorseSequence.add(inputMorse);

    if (inputMorseSequence[currentSymbolIndex] == expectedMorseSequence[currentSymbolIndex]) {
      typedMorseCode.value = tools.convertMorseEnumToString(inputMorseSequence);
      currentSymbolIndex++;
      if (currentSymbolIndex >= expectedMorseSequence.length) {
        nextCharacter();
        result.value = MorseChallengeResult.won;
      }
    } else {
      resetRound();
    }
  }
}