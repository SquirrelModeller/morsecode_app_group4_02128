import 'dart:async';
import 'package:english_words/english_words.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/morse_translator.dart';

class PracticeService {
  String randomWord = WordPair.random().toString().toUpperCase();
  int letterCount = 0;
  String morsText = "";
  String text = "";
  List<MorseState> morseCode = [];
  final Morsetranslator morsetranslator = Morsetranslator();

  String randomWordGen() {
    return WordPair.random().toString().toUpperCase();
  }

  void updateMorseText(String newText) {
    morsText = newText;
  }

  void clearMorseText() {
    morsText = "";
    morseCode.clear();
  }

  void updateText(String newLetter) {
    if (newLetter == randomWord[letterCount]) {
      text += newLetter;
      letterCount++;
    }

    if (letterCount == randomWord.length) {
      print("HUrray");
    }
  }

  void clearText() {
    text = "";
    letterCount = 0;
    clearMorseText();
  }

  void skipWord() {
    randomWord = WordPair.random().toString().toUpperCase();
    clearText();
  }

  

  

}
