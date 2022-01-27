import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner_app_flutter/utils/constants.dart';
import 'screens/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR code',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: yellowColor,
          secondary: yellowColor,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          foregroundColor: blackColor,
          backgroundColor: whiteColor,
          elevation: 5,
          shadowColor: blackColor.withOpacity(.15),
        ),
        scaffoldBackgroundColor: whiteColor,
      ),
      home: const HomeScreen(),
    );
  }
}
