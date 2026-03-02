import 'package:projet_examen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:projet_examen/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: "MétéoVision",
          debugShowCheckedModeBanner: false,
          theme: themeManager.currentTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}