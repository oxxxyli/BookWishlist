import 'package:flutter/material.dart';

class AddMethodSelector extends StatelessWidget {
  final VoidCallback onManualAdd; // Callback для открытия формы ручного ввода
  final VoidCallback onApiSearch; // Callback для будущей функции поиска/рекомендаций

  const AddMethodSelector({
    super.key,
    required this.onManualAdd,
    required this.onApiSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Как вы хотите добавить книгу?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // --- Кнопка 1: Ввести вручную (Использует существующий BookForm) ---
          ElevatedButton.icon(
            onPressed: onManualAdd,
            icon: const Icon(Icons.edit_note, size: 28),
            label: const Text('Ввести данные вручную'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
            ),
          ),
          const SizedBox(height: 15),

          // --- Кнопка 2: Найти в API (Будущие рекомендации/поиск) ---
          ElevatedButton.icon(
            onPressed: () {
              // TODO: В будущем здесь будет логика поиска по API
              onApiSearch();
            },
            icon: const Icon(Icons.search, size: 28),
            label: const Text('Найти в рекомендациях / API'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
            ),
          ),

          const SizedBox(height: 10),

          // Отмена
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}