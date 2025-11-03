import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  // Фиктивные данные для вёрстки (ЛР4)
  final List<Map<String, String>> mockReadBooks = const [
    {'title': 'Гордость и предубеждение', 'author': 'Джейн Остин'},
    {'title': '451 градус по Фаренгейту', 'author': 'Рэй Брэдбери'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Прочитано'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: mockReadBooks.length,
        itemBuilder: (context, index) {
          final book = mockReadBooks[index];
          return ListTile(
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
            // Можно добавить иконку, что книга прочитана
            trailing: const Icon(Icons.menu_book, color: Colors.indigo),
          );
        },
      ),
    );
  }
}