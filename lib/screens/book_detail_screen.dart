import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final Function(Book) onEditTapped;
  final Function(Book) onDeleteTapped; // Функции для редактирования и удаления

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onEditTapped,
    required this.onDeleteTapped,
  });

  // 🔑 МЕТОД: Диалог подтверждения удаления
  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтвердить удаление'),
        content: Text('Вы уверены, что хотите удалить книгу "${book.title}"? Это действие необратимо.'),
        backgroundColor: colorScheme.background,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Закрыть диалог
            },
            child: Text('Отмена', style: TextStyle(color: colorScheme.secondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Закрыть диалог
              onDeleteTapped(book); // Вызвать функцию удаления (которая закрывает экран)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          // Кнопка Редактировать
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEditTapped(book);
            },
          ),
          // Кнопка Удалить
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- СЕКЦИЯ 1: Обложка и Название ---
            _buildCoverAndTitle(context, colorScheme),

            const SizedBox(height: 30),

            // --- СЕКЦИЯ 2: Описание ---
            Text(
              'Описание',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            Text(
              book.description ?? 'Описание отсутствует.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 30),

            // --- СЕКЦИЯ 3: Дополнительная информация ---
            _buildInfoRow(
              context,
              icon: Icons.person,
              label: 'Автор:',
              value: book.author,
            ),
            _buildInfoRow(
              context,
              icon: book.isRead ? Icons.check_circle : Icons.list_alt,
              label: 'Статус:',
              value: book.isRead ? 'Прочитано' : 'В вишлисте',
              color: book.isRead ? Colors.green : colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // --- Вспомогательные методы для UI ---

  Widget _buildCoverAndTitle(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        // 1. 🔑 HERO WIDGET: Большая обложка
        Hero(
          tag: 'book-cover-${book.title}', // Используем ТОТ ЖЕ тег!
          child: Container(
            width: 150,
            height: 225,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              color: book.coverUrl == null ? colorScheme.primary : Colors.transparent,
            ),
            child: book.coverUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.image_not_supported, color: colorScheme.onPrimary, size: 50)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator(color: colorScheme.onPrimary));
                },
              ),
            )
                : Center(
              child: Icon(
                Icons.book,
                color: colorScheme.onPrimary,
                size: 70,
              ),
            ),
          ),
        ),

        // 2. Название
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        Color? color,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color ?? colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color ?? colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}