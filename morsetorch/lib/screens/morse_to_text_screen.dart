import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';
import 'package:morsetorch/models/language_map.dart';
import 'package:morsetorch/services/language_translator.dart';
import 'package:morsetorch/services/morse_translation_service.dart';
import 'package:morsetorch/widgets/custom_text_field.dart';

class MorseToTextScreen extends StatefulWidget {
  const MorseToTextScreen({super.key});

  @override
  _MorseToTextScreenState createState() => _MorseToTextScreenState();
}

class _MorseToTextScreenState extends State<MorseToTextScreen> {
  final TextEditingController _textController = TextEditingController();
  late MorseTranslationService morseService;

  late String selectedLanguage = "None";
  final List<String> _dropdownItems = languages.keys.toList();
  final nativeOpencv = McNativeOpencv();
  String languageID = "none";
  String textBoxText = 'Searching for morse signal...';
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    morseService = MorseTranslationService((translatedText) {
      setState(() {
        _textController.text = translatedText;
      });
    });
    initializeCameraService();
  }

  @override
  void dispose() {
    morseService.dispose();
    super.dispose();
  }

  Future<void> initializeCameraService() async {
    await morseService.initializeCamera();
    morseService.cameraController!.setZoomLevel(2.0);
    if (mounted) {
      setState(() {
        isCameraInitialized =
            morseService.cameraController?.value.isInitialized ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            isCameraInitialized
                ? CameraPreview(morseService.cameraController!)
                : const CircularProgressIndicator(),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 8/ 20,
                ),
                const Text(
                  'KEEP LIGHT WITHIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: CustomTextField(
                    controller: _textController,
                    color: const Color.fromARGB(150, 43, 42, 42),
                    text: textBoxText,
                    textColor: Colors.white,
                    maxHeight: MediaQuery.of(context).size.height / 7,
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
