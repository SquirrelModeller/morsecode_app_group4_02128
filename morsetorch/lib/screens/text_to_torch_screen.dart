import 'package:flutter/material.dart';
import 'package:morsetorch/services/text_to_torch_service.dart';
import 'package:morsetorch/widgets/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextToTorchScreen extends StatefulWidget {
  const TextToTorchScreen({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  State<TextToTorchScreen> createState() => _TextToTorchScreenState();
}

class _TextToTorchScreenState extends State<TextToTorchScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextToTorchService _torchService = TextToTorchService();
  bool _isButtonEnabled = false;
  double _currentValue = 1;
  int _currentIndex = -1;
  bool _switchValue = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMorseCodeSending() async {
    setState(() {
      _isButtonEnabled = !_isButtonEnabled;
    });

    if (_isButtonEnabled) {
      await _sendMorseCode();
    } else {
      _torchService.stopMorseCodeSending();
    }
  }

  Future<void> _sendMorseCode() async {
    String textToSend = _controller.text;
    textToSend = textToSend.replaceAll('\n', ' ');

    await _torchService.sendMorseCode(
        textToSend, 300 - (_currentValue.toInt()) * 100, _updateIndex);

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
                    child: CustomTextField(
                      controller: _controller,
                      maxHeight: MediaQuery.of(context).size.height / 2.3,
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Fast Mode',
                          style: TextStyle(
                            color: Color.fromARGB(255, 118, 118, 118),
                          ),
                        ),
                        Switch(
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                              _switchValue
                                  ? _currentValue = 2
                                  : _currentValue = 1;
                            });
                          },
                          activeColor: widget.isDarkMode
                              ? const Color.fromRGBO(5, 94, 132, 1)
                              : const Color.fromRGBO(0, 178, 255, 1),
                          inactiveThumbColor: widget.isDarkMode
                              ? const Color.fromARGB(255, 118, 118, 118)
                              : const Color.fromARGB(255, 255, 255, 255),
                          inactiveTrackColor: widget.isDarkMode
                              ? const Color.fromARGB(255, 150, 150, 150)
                              : const Color.fromARGB(255, 200, 200, 200),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                text: TextSpan(
                  children: List.generate(
                    _controller.text.length,
                    (index) {
                      return TextSpan(
                        text: _controller.text[index],
                        style: TextStyle(
                          fontSize: 24,
                          color: index <= _currentIndex
                              ? (widget.isDarkMode ? Colors.blue : Colors.blue)
                              : (widget.isDarkMode
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
