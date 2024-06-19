import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mc_native_opencv/mc_native_opencv.dart';
import 'package:morsetorch/models/language_map.dart';
import 'package:morsetorch/widgets/text_field.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _textController = TextEditingController();
  double textFieldHeight = 100;
  String? _selectedLanguage;
  final List<String> _dropdownItems = languages.keys.toList();
  final nativeOpencv = McNativeOpencv();
  String? languageID = "none";
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox.expand(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
                    textFieldHeight: textFieldHeight,
                    color: const Color.fromARGB(150, 43, 42, 42),
                    text: 'Searching for morse signal...',
                    textColor: Colors.white,
                    maxHeight: MediaQuery.of(context).size.height / 4,
                    canWrite: false,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  hint: Text('Select a Language'),
                  items: _dropdownItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue;
                      languageID = languages[_selectedLanguage];
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('--> OpenCV version: ${nativeOpencv.cvVersion()}');
          nativeOpencv.initLightTracker(100);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
