import 'package:flutter/material.dart';
import 'package:morsetorch/screens/practice.dart';
import 'package:morsetorch/screens/text_to_torch.dart';
import 'package:morsetorch/screens/torch_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MorseTorch',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 196, 223, 230),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 196, 223, 230),
        ),
      ),
      home: const Navigation(
        title: 'Morse Torch',
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.title});

  final String title;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 1;
  final screens = [
    const Practice(),
    TextToTorch(),
    const CameraScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'icons/Button3.png',
            ),
            label: 'Practice morse',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('icons/Flashlight2.png'),
            label: 'Text to Morse',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('icons/Flashlight.png'),
            label: 'Morse to Text',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
