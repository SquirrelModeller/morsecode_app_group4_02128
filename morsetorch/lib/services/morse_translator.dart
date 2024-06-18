import 'dart:math';
import 'dart:developer' as dev;
import 'package:morsetorch/models/morse_signal.dart';
import 'package:morsetorch/models/morse_state.dart';

class Morsetranslator {
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

  calculateTimeUnit(List<MorseSignal> morseCodeInput) {
    num timeUnit = 0;

    for (int i = 0; i < morseCodeInput.length - 1; i++) {
      num deltaTime = morseCodeInput[i + 1].time - morseCodeInput[i].time;
      if (timeUnit == 0 || timeUnit > deltaTime) {
        timeUnit = deltaTime;
      }
    }
    return timeUnit;
  }

  morseToText(List<MorseState> input) {
    return morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, input),
        orElse: () => throw Exception("Value has no key"));
  }

  timeframeToText(List<MorseSignal> morseCodeInput, num timeUnit) {
    num timePadding = 0.1; //Not a valid value for miliseconds
    String text = "";
    List<MorseState> character = [];
    for (int i = 0; i < morseCodeInput.length - 1; i++) {
      num deltaTime = morseCodeInput[i + 1].time - morseCodeInput[i].time;
      try {
        if (morseCodeInput[i].isOn == true &&
            (deltaTime < 1 * timeUnit + timePadding &&
                deltaTime > 1 * timeUnit - timePadding)) {
          character.add(MorseState.Dot);
        } else if (morseCodeInput[i].isOn == true &&
            (deltaTime < 3 * timeUnit + timePadding &&
                deltaTime > 3 * timeUnit - timePadding)) {
          character.add(MorseState.Dash);
        } else if (morseCodeInput[i].isOn == false &&
            (deltaTime < 3 * timeUnit + timePadding &&
                deltaTime > 3 * timeUnit - timePadding)) {
          text += morseToText(character);
          character = [];
        } else if (morseCodeInput[i].isOn == false &&
            (deltaTime < 7 * timeUnit + timePadding &&
                deltaTime > 7 * timeUnit - timePadding)) {
          text += "${morseToText(character)} ";
          character = [];
        } else if ((morseCodeInput[i].isOn == false &&
                (deltaTime < 1 * timeUnit + timePadding &&
                    deltaTime > 1 * timeUnit - timePadding)) ==
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
    return text;
  }
}

void main() {
  Morsetranslator translator = Morsetranslator();
  // var dataToTest = garbageData();

  var testData = [
    MorseSignal(false, 0),
    MorseSignal(true, 1 * 2),
    MorseSignal(false, 2 * 2),
    MorseSignal(true, 3 * 2),
    MorseSignal(false, 6 * 2),
    MorseSignal(true, 7 * 2),
    MorseSignal(false, 10 * 2)
  ];
  num time = translator.calculateTimeUnit(testData);
  print(translator.timeframeToText(testData, time));
}
