import 'package:flutter/material.dart';
import 'pages/timer_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时间管理工具',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          primary: const Color(0xFF4A90E2),
          secondary: const Color(0xFFFF6B6B),
          background: const Color(0xFFF5F7FA),
          surface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF636E72)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFFB2BEC3)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          color: Colors.white,
        ),
      ),
      home: const TimerPage(),
    );
  }
}
