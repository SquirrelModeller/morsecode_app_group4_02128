import 'dart:developer' as dev;
import 'package:morsetorch/models/morse_signal.dart';
import 'package:morsetorch/models/morse_state.dart';

class Morsetranslator {
  List<MorseSignal> morseReciveBuilder = [];
  int currentTimeUnit = 0;
  String currentText = "";
  textToMorse(String text) {
    var morseCodeSentence = [[]];
    text.runes.forEach((e) {
      String currentChar = String.fromCharCode(e).toUpperCase();
      if (currentChar == " ") {
        morseCodeSentence.add([]);
      } else {
        morseCodeSentence.last.add(morseCode[currentChar]);
      }
    });
    return morseCodeSentence;
  }

  compareEnum(List<MorseState> list1, List<MorseState> list2) {
    bool equal = true;
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] == MorseState.Dot && list2[i] == MorseState.Dash ||
          list1[i] == MorseState.Dash && list2[i] == MorseState.Dot) {
        equal = false;
      }
    }
    return equal;
  }
  
  void clearMorseBuilder(){
    morseReciveBuilder = [];
  }

  void addPackageToList(List<int> package){
    MorseSignal signal = MorseSignal(false, 0);
    signal.isOn = package[0] == 1 ? true : false;
    signal.time = package[1];
    morseReciveBuilder.add(signal);
  }

  calculateTimeUnit(List<MorseSignal> morseCodeInput) {
    int timeUnit = 0;
    for (int i = 0; i < morseCodeInput.length - 1; i++) {
      int deltaTime = morseCodeInput[i + 1].time - morseCodeInput[i].time;
      if (timeUnit == 0 || timeUnit > deltaTime) {
        timeUnit = deltaTime;
      }
    }
    currentTimeUnit = timeUnit;
  }

  morseToText(List<MorseState> input) {
    return morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, input),
        orElse: () => throw Exception("Value has no key"));
  }

  timeframeToText(List<MorseSignal> morseCodeInput) {
    int timePadding = 20; //Not a valid value for miliseconds
    String text = "";
    List<MorseState> character = [];
    for (int i = 0; i < morseCodeInput.length - 1; i++) {
      num deltaTime = morseCodeInput[i + 1].time - morseCodeInput[i].time;
      try {
        if (morseCodeInput[i].isOn == true &&
            (deltaTime < 1 * currentTimeUnit + timePadding &&
                deltaTime > 1 * currentTimeUnit- timePadding)) {
          character.add(MorseState.Dot);
        } else if (morseCodeInput[i].isOn == true &&
            (deltaTime < 3 * currentTimeUnit + timePadding &&
                deltaTime > 3 * currentTimeUnit - timePadding)) {
          character.add(MorseState.Dash);
        } else if (morseCodeInput[i].isOn == false &&
            (deltaTime < 3 * currentTimeUnit + timePadding &&
                deltaTime > 3 * currentTimeUnit - timePadding)) {
          text += morseToText(character);
          character = [];
        } else if (morseCodeInput[i].isOn == false &&
            (deltaTime < 7 * currentTimeUnit + timePadding &&
                deltaTime > 7 * currentTimeUnit - timePadding)) {
          text += "${morseToText(character)} ";
          character = [];
        } else if ((morseCodeInput[i].isOn == false &&
                (deltaTime < 1 * currentTimeUnit + timePadding &&
                    deltaTime > 1 * currentTimeUnit - timePadding)) ==
            false) {
          throw Exception(
              "Invalid Time frame. Position:$i DeltaTime:$deltaTime");
        }
        if (i == morseCodeInput.length - 2) {
          text += morseToText(character);
        }
      } catch (e) {
        dev.log("$e");
      }
    }
    currentText = text;
  }
}