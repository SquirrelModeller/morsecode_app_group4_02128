import 'dart:developer';

import 'package:translator/translator.dart';

translateText(String text, String language) async {
  if (language == "none") {
    return text;
  }
  try {
    final translator = GoogleTranslator();
    var translation = translator.translate(text, to: language);
    return translation;
  } catch (e) {
    log("Can't Translate with no network");
  }
}
