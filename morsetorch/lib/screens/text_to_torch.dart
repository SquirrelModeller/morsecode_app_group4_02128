import 'package:flutter/material.dart';
import 'package:morsetorch/services/torch_service.dart';
import 'package:morsetorch/widgets/text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextToTorch extends StatefulWidget {
  TextToTorch({super.key, required this.isDarkMode});
  bool isDarkMode;

  @override
  State<TextToTorch> createState() => _TextToTorchState();
}

class _TextToTorchState extends State<TextToTorch> {
  final TextEditingController _controller = TextEditingController();
  double textFieldHeight = 200;
  final TorchService _torchService = TorchService();
  bool _isButtonEnabled = false;
  double _currentSliderValue = 5;
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  void _toggleMorseCodeSending() async {
    setState(() {
      _isButtonEnabled = !_isButtonEnabled;
    });

    if (_isButtonEnabled) {
      _sendMorseCode();
    } else {
      _torchService.stopMorseCodeSending();
    }
  }

  Future<void> _sendMorseCode() async {
    String textToSend = _controller.text;
    textToSend = textToSend.replaceAll('\n', ' ');

    await _torchService.sendMorseCode(
        textToSend, 325 - (_currentSliderValue.toInt()) * 25, _updateIndex);

    setState(() {
      _isButtonEnabled = false;
      _currentIndex = -1;
    });
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SafeArea(
                    child: ExpandableTextField(
                      controller: _controller,
                      textFieldHeight: 150,
                      maxHeight: MediaQuery.of(context).size.height / 2.2,
                      text: 'Enter text to convert to morse',
                      textColor: widget.isDarkMode
                          ? const Color.fromARGB(255, 202, 202, 202)
                          : const Color.fromARGB(255, 118, 118, 118),
                      color: widget.isDarkMode
                          ? const Color.fromARGB(255, 118, 118, 118)
                          : Colors.white,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        FloatingActionButton.large(
                          shape: const CircleBorder(eccentricity: 0.0),
                          elevation: 10,
                          backgroundColor: Colors.transparent,
                          onPressed: _toggleMorseCodeSending,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              widget.isDarkMode
                                  ? const Color.fromARGB(255, 10, 10, 10)
                                      .withOpacity(0.5)
                                  : const Color.fromARGB(255, 10, 10, 10)
                                      .withOpacity(0.0),
                              BlendMode.srcATop,
                            ),
                            child: _isButtonEnabled
                                ? SvgPicture.asset('icons/button2.svg')
                                : SvgPicture.asset('icons/button.svg'),
                          ),
                        ),
                        Slider(
                          activeColor: widget.isDarkMode
                              ? const Color.fromRGBO(5, 94, 132, 1)
                              : const Color.fromRGBO(0, 178, 255, 1),
                          inactiveColor: widget.isDarkMode
                              ? const Color.fromARGB(255, 118, 118, 118)
                              : const Color.fromARGB(255, 255, 255, 255),
                          value: _currentSliderValue,
                          min: 1,
                          max: 9,
                          divisions: 8,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Wrap(
                    children: List.generate(_controller.text.length, (index) {
                      return Text(
                        _controller.text[index],
                        style: TextStyle(
                          fontSize: 24,
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      );
                    }),
                  ),
                  if (_currentIndex >= 0)
                    Positioned(
                      left: _calculatePosition(_controller.text, _currentIndex),
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculatePosition(String text, int index) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.substring(0, index),
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }
}
