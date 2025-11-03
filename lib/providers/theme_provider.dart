import 'package:flutter/material.dart';

// 📚 Теплые цвета
class AppColors {
  // Светлая тема
  static const Color lightPrimary = Color(0xFFC8A79B); // Теплый бежевый/розовый
  static const Color lightAccent = Color(0xFF8B4513);  // Шоколадный
  static const Color lightBackground = Color(0xFFF5F5DC); // Цвет слоновой кости

  // Темная тема
  static const Color darkPrimary = Color(0xFF4B3832);   // Темный коричневый
  static const Color darkAccent = Color(0xFFEBC79E);    // Светлый беж
  static const Color darkBackground = Color(0xFF1E1C1A); // Почти черный
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // По умолчанию - системная

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); // Уведомляем виджеты об изменении
  }

  // Ключевой метод: Создание светлой темы
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightAccent,
        background: AppColors.lightBackground,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.lightAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.lightBackground,
      ),
      // Добавьте больше настроек темы здесь
    );
  }

  // Ключевой метод: Создание темной темы
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        background: AppColors.darkBackground,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkAccent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkAccent,
        foregroundColor: AppColors.darkPrimary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.darkAccent,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: AppColors.darkBackground,
      ),
      // Добавьте больше настроек темы здесь
    );
  }
}