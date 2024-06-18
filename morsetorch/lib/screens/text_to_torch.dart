import 'package:flutter/material.dart';
import 'package:morsetorch/services/torch_service.dart';
import 'package:morsetorch/widgets/text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextToTorch extends StatefulWidget {
  const TextToTorch({super.key});

  @override
  State<TextToTorch> createState() => _TextToTorchState();
}

class _TextToTorchState extends State<TextToTorch> {
  final TextEditingController _controller = TextEditingController();
  double textFieldHeight = 200;
  final TorchService _torchService = TorchService();

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
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      text: 'Enter text to convert to morse',
                      textColor: const Color.fromARGB(255, 118, 118, 118),
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
                          onPressed: () {
                            _torchService.sendMorseCode(_controller.text, 100);
                          },
                          child: SvgPicture.asset('icons/button.svg'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
