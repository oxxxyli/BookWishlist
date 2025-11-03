import 'package:flutter/material.dart';
import '../models/book.dart';

class EditBookForm extends StatefulWidget {
  final Book initialBook; // Книга, которую редактируем
  final Function(Book oldBook, String newTitle, String newAuthor) onUpdate;

  const EditBookForm({
    super.key,
    required this.initialBook,
    required this.onUpdate,
  });

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    // 🔑 Предзаполнение полей текущими значениями
    _titleController = TextEditingController(text: widget.initialBook.title);
    _authorController = TextEditingController(text: widget.initialBook.author);
  }

  // 🔑 ЛОГИКА: Обработка обновления
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final newTitle = _titleController.text.trim();
      final newAuthor = _authorController.text.trim();

      // Вызываем переданный callback для обновления
      widget.onUpdate(widget.initialBook, newTitle, newAuthor);

      // Закрываем модальное окно
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Редактировать книгу',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Поле ввода (Название)
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Название книги',
                  labelStyle: TextStyle(color: colorScheme.secondary),
                  prefixIcon: Icon(Icons.title, color: colorScheme.secondary.withOpacity(0.7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: colorScheme.secondary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите название книги.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле ввода (Автор)
              TextFormField(
                controller: _authorController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Автор',
                  labelStyle: TextStyle(color: colorScheme.secondary),
                  prefixIcon: Icon(Icons.person, color: colorScheme.secondary.withOpacity(0.7)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: colorScheme.secondary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите имя автора.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Кнопка "Сохранить изменения"
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  elevation: 5,
                ),
                child: const Text(
                  'Сохранить изменения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Отмена',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}