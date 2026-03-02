import 'package:flutter/material.dart';
import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import '../widgets/waiting_message.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDarkMode = themeManager.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MétéoVision',
          style: TextStyle(
            color: Colors.white,
            fontFamily: family,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeManager.toggleTheme();
            },
          ),
        ],
      ),
      body: const Center(
        child: WaitingMessage(),
      ),
    );
  }
}