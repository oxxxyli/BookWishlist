import 'package:flutter/material.dart';
import 'screens/wishlist_screen.dart'; // Импорт первого экрана
// import 'screens/read_screen.dart'; // Раскомментировать для проверки второго экрана
// import 'widgets/book_form.dart'; // Раскомментировать для проверки формы

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Wishlist',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Базовая стилизация
      ),
      // 1. const WishlistScreen()
      // 2. const ReadScreen()
      // 3. Scaffold(appBar: AppBar(title: const Text('Форма')), body: const BookForm())
      home: const WishlistScreen(),
    );
  }
}