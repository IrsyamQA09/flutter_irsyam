import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CampusGoApp());
}

class CampusGoApp extends StatelessWidget {
  const CampusGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}