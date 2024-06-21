import 'dart:developer' as dev;
import 'dart:typed_data';
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

  void clearMorseBuilder() {
    morseReciveBuilder = [];
  }

  void addPackageToList(Int64List package) {
    for (int i = 0; i < package.length; i += 2) {
      morseReciveBuilder.add(MorseSignal(package[i] == 1, package[i + 1]));
    }
  }

  String returnText() {
    int timeUnit = calculateTimeUnit();
    return timeframeToText(morseReciveBuilder, timeUnit);
  }

  calculateTimeUnit() {
    List<int> differences = [];

    for (int i = 0; i < morseReciveBuilder.length - 1; i++) {
      int currentUnixTime = morseReciveBuilder[i].time;
      int nextUnixTime = morseReciveBuilder[i + 1].time;
      int difference = nextUnixTime - currentUnixTime;
      differences.add(difference);
    }

    differences.sort();
    var oneUnitTimes = [];
    for (int i = 0; i < differences.length - 1; i++) {
      if (differences[i + 1] > differences[i] * 2) {
        oneUnitTimes = differences.sublist(0, i);
        break;
      }
    }

    int sum = oneUnitTimes.reduce((a, b) => a + b);
    int averageTimeUnit = (sum / oneUnitTimes.length) as int;
    return averageTimeUnit;
  }

  morseToText(List<MorseState> input) {
    return morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, input),
        orElse: () => throw Exception("Value has no key"));
  }

  timeframeToText(List<MorseSignal> morseCodeInput, int timeUnit) {
    int timePadding = 50; //Not a valid value for miliseconds
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
