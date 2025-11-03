import 'package:flutter/material.dart';

class BookForm extends StatelessWidget {
  const BookForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold в данном случае нужен, если форма будет открываться как новый экран.
    // Если это модальное окно, Scaffold не нужен, но для простоты вёрстки оставим.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Чтобы Column занимала минимум места по высоте
        children: <Widget>[
          const Text(
            'Добавить новую книгу',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Поле для Названия книги
          const TextField(
            decoration: InputDecoration(
              labelText: 'Название книги',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Поле для Автора
          const TextField(
            decoration: InputDecoration(
              labelText: 'Автор',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // Кнопка добавления (пока без логики)
          ElevatedButton(
            onPressed: null, // onPressed: null делает кнопку неактивной
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), // Делаем кнопку широкой
            ),
            child: const Text('Добавить', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}