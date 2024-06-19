import 'package:flutter/material.dart';

class ExpandableTextField extends StatefulWidget {
  final TextEditingController controller;
  final double textFieldHeight;
  final Color color;
  final String text;
  final Color textColor;
  final double maxHeight;
  final bool canWrite;

  const ExpandableTextField(
      {super.key,
      required this.controller,
      required this.textFieldHeight,
      this.color = Colors.white,
      this.text = '',
      this.textColor = Colors.black,
      this.maxHeight = 300,
      this.canWrite = true});

  @override
  State<ExpandableTextField> createState() => _ExpandableTextFieldState();
}

class _ExpandableTextFieldState extends State<ExpandableTextField> {
  double textFieldHeight = 200;

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
            readOnly: !widget.canWrite,
            enabled: widget.canWrite,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.text,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
              hintStyle: TextStyle(color: widget.textColor),
            ),
            maxLines: null,
            expands: true,
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
