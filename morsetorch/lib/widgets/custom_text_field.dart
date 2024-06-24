import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final Color color;
  final String text;
  final Color textColor;
  final double maxHeight;
  final bool canWrite;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.color = Colors.white,
      this.text = '',
      this.textColor = Colors.black,
      this.maxHeight = 300,
      this.canWrite = true});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  double textFieldHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: textFieldHeight,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            style: TextStyle(color: widget.textColor),
            readOnly: !widget.canWrite,
            enabled: widget.canWrite,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.text,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
              hintStyle: TextStyle(color: widget.textColor),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'))
            ],
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              textFieldHeight += details.delta.dy;
              if (textFieldHeight < 50) {
                textFieldHeight = 50;
              }
              if (textFieldHeight > widget.maxHeight) {
                textFieldHeight = widget.maxHeight;
              }
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDown,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 30,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
