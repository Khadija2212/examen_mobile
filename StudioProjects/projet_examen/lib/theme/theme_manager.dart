import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF387ADF),
    scaffoldBackgroundColor: const Color(0xFF0D0D1A),
    cardColor: const Color(0xFF1A1A2E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF387ADF),
      secondary: Color(0xFF50C2C9),
      surface: Color(0xFF1A1A2E),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF333A73),
    scaffoldBackgroundColor: const Color(0xFFF0F4FF),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF333A73),
      secondary: Color(0xFF387ADF),
      surface: Colors.white,
      onSurface: Color(0xFF1A1A2E),
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF333A73),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF333A73)),
  );
}