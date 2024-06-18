import 'package:flutter/material.dart';
import 'package:morsetorch/services/torch_service.dart';

class TextToTorch extends StatelessWidget {
  TextToTorch({super.key});
  final TextEditingController _controller = TextEditingController();
  final TorchService _torchService = TorchService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Torch'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  labelText: 'Enter text to convert to Morse Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _torchService.sendMorseCode(_controller.text, 100);
              },
              child: const Text('Send Morse Code'),
            ),
          ],
        ),
      ),
    );
  }
}