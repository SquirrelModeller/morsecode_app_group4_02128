import 'package:flutter/material.dart';
import 'package:morsetorch/models/morse_state.dart';
import 'package:morsetorch/services/function_morse_tools.dart';
import 'package:morsetorch/widgets/custom_back_button.dart';

class MorseCodeDictionaryScreen extends StatefulWidget {
  final Function(int) setScreen;
  final bool isDarkMode;

  const MorseCodeDictionaryScreen(
      {super.key, required this.setScreen, required this.isDarkMode});

  @override
  State<MorseCodeDictionaryScreen> createState() =>
      _MorseCodeDictionaryScreenState();
}

class _MorseCodeDictionaryScreenState extends State<MorseCodeDictionaryScreen> {
  final FunctionMorseTools morseTools = FunctionMorseTools();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: ListView.builder(
                    itemCount: morseCode.length,
                    itemBuilder: (context, index) {
                      String letter = morseCode.keys.elementAt(index);
                      String code = morseTools.convertMorseEnumToString(morseCode[letter]!);
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 2,
                          ),
                          child: SizedBox(
                            width: 300.0,
                            child: ListTile(
                              title: Container(
                                width: 40,
                                height: 40,
                                child: Text(
                                  '$letter  $code',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 118, 118, 118),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomBackButton(
          isDarkMode: widget.isDarkMode,
          onPressed: () => widget.setScreen(0),
        ),
      ],
    );
  }
}
