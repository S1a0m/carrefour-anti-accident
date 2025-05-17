import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/carrefour_screen.dart';
import 'screens/sanctions_screen.dart';

void main() => runApp(CarrefourApp());

class CarrefourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrefour App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/carrefour': (context) => CarrefourScreen(),
        '/sanctions': (context) => SanctionsScreen(),
      },
    );
  }
}
