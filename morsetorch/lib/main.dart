import 'package:flutter/material.dart';
import 'package:morsetorch/screens/practice.dart';
import 'package:morsetorch/screens/text_to_torch.dart';
import 'package:morsetorch/screens/torch_to_text.dart';
import 'package:morsetorch/theme/color_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MorseTorch',
      theme: _isDarkMode ? darkMode : lightMode,
      home: Navigation(
        title: 'Morse Torch',
        toggleTheme: _toggleTheme,
      ),
    );
  }
}



class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.title,required this.toggleTheme});

  final String title;
  final VoidCallback toggleTheme;

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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: widget.toggleTheme, 
          icon: Icon(Icons.brightness_6))
        ],),
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
