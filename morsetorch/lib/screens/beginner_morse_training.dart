import 'package:flutter/material.dart';

class BeginnerMorseTrainingPage extends StatefulWidget {
  var setScreen;

  BeginnerMorseTrainingPage({super.key, required this.setScreen});

  @override
  State<BeginnerMorseTrainingPage> createState() =>
      _BeginnerMorseTrainingPageState();
}

class _BeginnerMorseTrainingPageState extends State<BeginnerMorseTrainingPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 35,
          left: 20,
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                widget.setScreen(0);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 9), // Space at the top
              Text(
                'Choose the correct one',
                style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
              ),
            ],
          ),
        ),
      ],
      
    );
  }
}
