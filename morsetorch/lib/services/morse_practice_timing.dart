import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/function_morse_tools.dart';
import 'package:morsetorch/services/morse_translator.dart';

enum MorseChallengeResult { pass, tooLate, tooSoon, inProgress, won }

enum GameDifficulty { easy, normal, hard }

class MorsePracticeTiming {
  ValueNotifier<MorseChallengeResult> result =
      ValueNotifier(MorseChallengeResult.inProgress);
  ValueNotifier<String> currentCharacter = ValueNotifier('');
  ValueNotifier<String> morseCode = ValueNotifier('');
  ValueNotifier<String> typedMorseCode = ValueNotifier('');
  ValueNotifier<int> pressSpeed = ValueNotifier(300);
  ValueNotifier<int> timePressed = ValueNotifier(0);

  ValueNotifier<int> lives = ValueNotifier(3);

  Map<String, int> completedCharacters = {};

  FunctionMorseTools tools = FunctionMorseTools();
  HandleInput inputHandler = HandleInput();
  List<MorseState> expectedMorseSequence = [];
  List<MorseState> inputMorseSequence = [];
  int currentSymbolIndex = 0;

  int threshHold = 0;

  MorsePracticeTiming(GameDifficulty mode) {
    switch (mode) {
      case GameDifficulty.easy:
        threshHold = 160;
        break;
      case GameDifficulty.normal:
        threshHold = 80;
        break;
      case GameDifficulty.hard:
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

    dev.log(completedCharacters[currentCharacter.value].toString());
    if ((completedCharacters[currentCharacter.value] ?? 0) > 5) {
      morseCode.value = '';
    }
    resetRound();
  }

  void updatePressedSpeed() {
    if (expectedMorseSequence == []) {
      return;
    }
    pressSpeed.value =
        expectedMorseSequence[currentSymbolIndex] == MorseState.Dot ? 100 : 300;
  }

  void startedPress() {
    updatePressedSpeed();
    inputHandler.startPress();
  }

  void stoppedPress() {
    inputHandler.stopPress();
    evaluateInput();
  }

  void incrementMapValue(Map<String, int> map, String key, int number) {
    map[key] = (map[key] ?? 0) + number;
  }

  void skipCharacter() {
    incrementMapValue(completedCharacters, currentCharacter.value, -1);
    nextCharacter();
  }

  void decrementLives() {
    if (lives.value > 0) {
      lives.value--;
      result.value = MorseChallengeResult.tooLate;
      resetRound();
      if (lives.value == 0) {
        // Implement game over logic or disable further input
      }
    }
  }

  void evaluateInput() {
    int duration = inputHandler.timePressed;
    timePressed.value = duration;
    updatePressedSpeed();
    MorseState inputMorse;

    if (pressSpeed.value - threshHold > duration) {
      result.value = MorseChallengeResult.tooSoon;
      return;
    }
    if (pressSpeed.value + threshHold < duration) {
      result.value = MorseChallengeResult.tooLate;
      return;
    }
    result.value = MorseChallengeResult.pass;

    inputMorse = expectedMorseSequence[currentSymbolIndex];

    inputMorseSequence.add(inputMorse);

    if (inputMorseSequence[currentSymbolIndex] ==
        expectedMorseSequence[currentSymbolIndex]) {
      typedMorseCode.value = tools.convertMorseEnumToString(inputMorseSequence);
      currentSymbolIndex++;
      if (currentSymbolIndex >= expectedMorseSequence.length) {
        incrementMapValue(completedCharacters, currentCharacter.value, 1);
        nextCharacter();
        result.value = MorseChallengeResult.won;
      }
    } else {
      resetRound();
    }
  }
}
