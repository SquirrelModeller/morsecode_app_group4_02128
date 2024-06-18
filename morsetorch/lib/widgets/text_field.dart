import 'package:flutter/material.dart';

class ExpandableTextField extends StatefulWidget {
  TextEditingController controller;
  double textFieldHeight;
  ExpandableTextField(
      {super.key, required this.controller, required this.textFieldHeight});

  @override
  State<ExpandableTextField> createState() => _ExpandableTextFieldState();
}

class _ExpandableTextFieldState extends State<ExpandableTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          height: widget.textFieldHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              hintText: 'Enter text to convert to morse',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
            ),
            maxLines: null,
            expands: true,
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              widget.textFieldHeight += details.delta.dy;
              if (widget.textFieldHeight < 50) {
                widget.textFieldHeight = 50;
              }
              if (widget.textFieldHeight > 300) {
                widget.textFieldHeight = 300;
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
                      color: Colors.white,
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
                      color: Colors.white,
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
