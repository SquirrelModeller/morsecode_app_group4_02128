import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morsetorch/screens/morse_training.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MorseTorch',
      theme: _isDarkMode ? darkMode : lightMode,
      home: Navigation(
        title: 'Morse Torch',
        toggleTheme: _toggleTheme,
        isDark: _isDarkMode,
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  Navigation(
      {super.key,
      required this.title,
      required this.toggleTheme,
      required this.isDark});

  final String title;
  final VoidCallback toggleTheme;
  bool isDark;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 1;
  List<Widget> getScreens() {
    return [
      MorseTrainingPage(),
      TextToTorch(
        isDarkMode: widget.isDark,
      ),
      const CameraScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          getScreens()[_currentIndex],
          Positioned(
            top: 35,
            right: 20,
            child: SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  widget.toggleTheme();
                },
                backgroundColor: widget.isDark
                    ? const Color.fromARGB(255, 5, 20, 36)
                    : Colors.white,
                child: const Icon(
                  Icons.brightness_6,
                  color: Color.fromARGB(255, 118, 118, 118),
                ),
                
              ),
            ),
          ),
        ],
      ),
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
