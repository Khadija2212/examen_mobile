import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
      primaryColor: const Color(0xFF333A73),
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF387ADF),
        secondary: const Color(0xFF333A73),
      ),
    )
        : ThemeData.light().copyWith(
      primaryColor: const Color(0xFF387ADF),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF387ADF),
        secondary: const Color(0xFF333A73),
      ),
    );
  }
}