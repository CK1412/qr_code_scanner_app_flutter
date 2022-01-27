import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app_flutter/utils/constants.dart';
import 'package:qr_code_scanner_app_flutter/screens/qr_code_generator_screen.dart';
import 'package:qr_code_scanner_app_flutter/screens/qr_code_scanner_screen.dart';
import 'package:qr_code_scanner_app_flutter/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          WelcomeScreen(),
          QRCodeGeneratorScreen(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'Welcome',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'Generate',
              ),
            ],
            backgroundColor: blackColor,
            selectedItemColor: yellowColor,
            unselectedItemColor: Colors.grey[700],
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  _currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRCodeScannerScreen(),
          ));
        },
        child: const Icon(Icons.qr_code_scanner_rounded),
        tooltip: 'Scan QR code',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
