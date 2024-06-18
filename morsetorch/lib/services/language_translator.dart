import 'package:translator/translator.dart';

void main() async {
  try {
    print(await translateText("dette er super hurtigt", "zh-tw"));
  }
  catch (e){
    print("Can't Translate with no network");
  }
}

translateText(String text, String language) async {
  final translator = GoogleTranslator();
  var translation = translator.translate(text, to: language);
  return translation;  
  

}