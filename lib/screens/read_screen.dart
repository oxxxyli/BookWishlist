import 'package:flutter/material.dart';
import '../models/book.dart';

class ReadScreen extends StatelessWidget {
  final List<Book> books;

  const ReadScreen({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Прочитано'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: books.isEmpty
          ? const Center(child: Text('Вы пока ничего не прочитали!'))
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: const Icon(Icons.menu_book, color: Colors.indigo),
          );
        },
      ),
    );
  }
}