import 'package:flutter/material.dart';
import '../widgets/book_form.dart'; // Импортируем форму

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  // Фиктивные данные для вёрстки (ЛР4)
  final List<Map<String, String>> mockBooks = const [
    {'title': 'Имя ветра', 'author': 'Патрик Ротфусс'},
    {'title': 'Шантарам', 'author': 'Грегори Дэвид Робертс'},
    {'title': 'Мастер и Маргарита', 'author': 'Михаил Булгаков'},
    {'title': 'Унесенные ветром', 'author': 'Маргарет Митчелл'},
  ];

  void _showAddBookModal(BuildContext context) {
    // В ЛР5 здесь будет реальный показ модального окна,
    // пока эта функция просто для демонстрации.
    print('Нажата кнопка добавления книги!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Вишлист'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: mockBooks.length,
        itemBuilder: (context, index) {
          final book = mockBooks[index];
          return ListTile(
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: null, // Пока без логики
            ),
            onTap: null, // Пока без логики
          );
        },
      ),
      // Плавающая кнопка для добавления книги
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookModal(context),
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}