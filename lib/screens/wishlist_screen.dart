import 'package:flutter/material.dart';
import '../models/book.dart';

class WishlistScreen extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onMarkAsRead;
  final VoidCallback onAddTapped;

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
            subtitle: Text(
              // Отображаем автора и описание, если оно есть
              '${book.author}${book.description != null ? '\nОписание: ${book.description!}' : ''}',
              maxLines: book.description != null ? 3 : 1, // Позволяем субтитрам занимать больше места
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: book.description != null, // Делаем его многострочным
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () => onMarkAsRead(book),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTapped,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}