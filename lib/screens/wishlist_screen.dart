import 'package:flutter/material.dart';
import '../models/book.dart';

class WishlistScreen extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onMarkAsRead; // Callback для отметки "Прочитано"
  final VoidCallback onAddTapped; // Callback для вызова модального окна

  const WishlistScreen({
    super.key,
    required this.books,
    required this.onMarkAsRead,
    required this.onAddTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Вишлист'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: books.isEmpty
          ? const Center(child: Text('Ваш вишлист пуст!'))
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              // !!! ЛОГИКА: Вызываем переданную функцию при нажатии !!!
              onPressed: () => onMarkAsRead(book),
            ),
            onTap: () {
              // В ЛР6 здесь можно будет показать детали
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTapped, // !!! ЛОГИКА: Вызываем callback для показа формы !!!
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}