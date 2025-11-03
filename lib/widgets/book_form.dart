import 'package:flutter/material.dart';

class BookForm extends StatefulWidget {
  final Function(String title, String author) onAdd; // Callback для добавления книги

  const BookForm({super.key, required this.onAdd});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  // 🔑 ЛОГИКА: Обработка добавления
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAuthor = _authorController.text;

    // Проверка на пустые поля
    if (enteredTitle.isEmpty || enteredAuthor.isEmpty) {
      return;
    }

    // Вызываем переданный callback, который обновит состояние в HomePage
    widget.onAdd(enteredTitle, enteredAuthor);

    // Закрываем модальное окно
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Добавить новую книгу',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Название книги',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submitData(), // Отправка по Enter
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Автор',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submitData(), // Отправка по Enter
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submitData, // Вызываем логику отправки
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Добавить', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}