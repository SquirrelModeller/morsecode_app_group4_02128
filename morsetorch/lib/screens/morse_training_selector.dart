import 'package:flutter/material.dart';
import 'package:morsetorch/screens/morse_training.dart';

class MorseTrainingSelectorPage extends StatefulWidget {
  const MorseTrainingSelectorPage({super.key});

  @override
  MorseTrainingSelectorPageState createState() =>
      MorseTrainingSelectorPageState();
}

class MorseTrainingSelectorPageState extends State<MorseTrainingSelectorPage> {
  bool advanced = false;

  @override
  Widget build(BuildContext context) {
    return advanced
        ? MorseTrainingPage()
        : Scaffold(
            body: Center(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 9),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Beginner',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 9),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            advanced = true;
                          });
                        },
                        child: Text(
                          'Advanced',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21),
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
