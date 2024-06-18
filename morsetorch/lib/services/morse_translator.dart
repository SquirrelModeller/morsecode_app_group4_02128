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

  compareEnum (List<MorseState> list1, List<MorseState> list2){
    bool equal = true;
    if (list1.length != list2.length){
      return false;
    }
    for (int i = 0; i < list1.length; i++){
      if (list1[i] == MorseState.Dot && list2[i] == MorseState.Dash || list1[i] == MorseState.Dash && list2[i] == MorseState.Dot){
        equal = false;
      }
    }
    return equal;
  }

  morseToText(List<MorseSignal> morseCodeInput) {
    const num timeUnit = 1;
    const num timePadding = 0.05;

    String text = "";
    List<MorseState> character = [];
    for (int i = 0; i < morseCodeInput.length-1; i++){
      num deltaTime = morseCodeInput[i+1].time-morseCodeInput[i].time;
      try {
        if(morseCodeInput[i].isOn == true && (deltaTime < 1*timeUnit+timePadding && deltaTime > 1*timeUnit-timePadding)){
          character.add(MorseState.Dot);
        } else if (morseCodeInput[i].isOn == true && (deltaTime < 3*timeUnit+timePadding && deltaTime > 3*timeUnit-timePadding)){
          character.add(MorseState.Dash);
        } else if (morseCodeInput[i].isOn == false && (deltaTime < 3*timeUnit+timePadding && deltaTime > 3*timeUnit-timePadding)){
          text += morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, character), orElse: () => throw Exception("Value has no key"));
          character = [];
        } else if (morseCodeInput[i].isOn == false && (deltaTime < 7*timeUnit+timePadding && deltaTime > 7*timeUnit-timePadding)){
          text += "${morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, character), orElse: () => throw Exception("Value has no key"))} ";
          character = [];
        } else if ((morseCodeInput[i].isOn == false && (deltaTime < 1*timeUnit+timePadding && deltaTime > 1*timeUnit-timePadding))== false){
         throw Exception("Invalid Time frame. Position:$i DeltaTime:$deltaTime"); 

        } if(i == morseCodeInput.length-2){
          text += morseCode.keys.firstWhere((k) => compareEnum(morseCode[k]!, character), orElse: () => throw Exception("Value has no key"));
        }
      }
      catch (e){
        print("$e");
      }
    }
    return text;
  }
}

List<MorseSignal> garbageData() {
  List<MorseSignal> randomData = [];
  for (int i = 0; i < 40; i++) {
    randomData.add(MorseSignal(i%2 == 0 ? true : false, Random.secure().nextInt(3+i)+i));
  }
  return randomData;
}

void main() {
  Morsetranslator translator = Morsetranslator();
  // var dataToTest = garbageData();
  var testData = [MorseSignal(true, 0),MorseSignal(false, 1),MorseSignal(true, 2),MorseSignal(false, 5),MorseSignal(true, 6),MorseSignal(false, 9),MorseSignal(true, 10),MorseSignal(false, 11),MorseSignal(true, 12),MorseSignal(false, 15)];
  dev.log(translator.morseToText(testData));
}
