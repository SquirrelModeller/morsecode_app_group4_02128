import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';
import 'package:morsetorch/models/language_map.dart';
import 'package:morsetorch/screens/morse_detection.dart';
import 'package:morsetorch/services/language_translator.dart';
import 'package:morsetorch/widgets/text_field.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final TextEditingController _textController = TextEditingController();
  late String selectedLanguage = "None";
  final List<String> _dropdownItems = languages.keys.toList();
  final nativeOpencv = McNativeOpencv();
  String languageID = "none";
  String textBoxText ='Searching for morse signal...';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox.expand(
              child: MorseDetection(),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'KEEP LIGHT WITHIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  margin: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ExpandableTextField(
                    controller: _textController,
                    color: const Color.fromARGB(150, 43, 42, 42),
                    text: textBoxText,
                    textColor: Colors.white,
                    maxHeight: MediaQuery.of(context).size.height / 5,
                    canWrite: false,
                  ),
                ),
                DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(150, 43, 42, 42),
                  value: selectedLanguage,
                  hint: const Text(
                    'Select a Language',
                    style: TextStyle(color: Colors.white),
                  ),
                  items: _dropdownItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                      languageID = languages[selectedLanguage]!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           var newText = await translateText(_textController.text, languageID);
          _textController.text = newText.toString();
        },
        child: const Icon(
          Icons.translate,
        ),
      ),
    );
  }
}
