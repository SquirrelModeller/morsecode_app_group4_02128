import 'dart:developer' as dev;
import 'dart:math';
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

    Map<String, int> counts100 = classifyTimeDifferences(differences, 100);
    Map<String, int> counts200 = classifyTimeDifferences(differences, 200);

    int total100 = counts100.values.reduce((a, b) => (a) + (b));
    int total200 = counts200.values.reduce((a, b) => (a) + (b));

    return total100 > total200 ? 100 : 200;
  }

  Map<String, int> classifyTimeDifferences(
      List<int> differences, int timeUnit) {
    Map<String, int> counts = {
      '1 unit': 0,
      '3 unit': 0,
      '7 unit': 0,
    };

    for (var diff in differences) {
      if (diff >= timeUnit - 50 && diff <= timeUnit + 50) {
        counts['1 unit'] = (counts['1 unit'] ?? 0) + 1;
      } else if (diff >= 3 * timeUnit - 50 && diff <= 3 * timeUnit + 50) {
        counts['3 unit'] = (counts['3 unit'] ?? 0) + 1;
      } else if (diff >= 7 * timeUnit - 50 && diff <= 7 * timeUnit + 50) {
        counts['7 unit'] = (counts['7 unit'] ?? 0) + 1;
      }
    }
    return counts;
  }

  morseToText(List<MorseState> input) {
    return morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, input),
        orElse: () => throw Exception("Value has no key $input"));
  }

  timeframeToText(List<MorseSignal> morseCodeInput, int timeUnit) {
    int timePadding = 100; //Not a valid value for miliseconds
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
          dev.log("New Character");
          text += morseToText(character);
          character = [];
        } else if (morseCodeInput[i].isOn == false &&
            (deltaTime < 7 * timeUnit + timePadding &&
                deltaTime > 7 * timeUnit - timePadding)) {
          dev.log("New Space");
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
          character = [];
        }
      } catch (e) {
        dev.log("$e");
      }
    }
    return text;
  }
}
