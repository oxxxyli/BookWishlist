import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import '../widgets/book_card.dart';

class BookSearchScreen extends StatefulWidget {
  final Function(Book) onBookSelected; // Callback для добавления книги в список

  const BookSearchScreen({
    super.key,
    required this.onBookSelected,
  });

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  String _message = 'Введите название книги или автора для поиска.';

  // 🔑 ЛОГИКА ПОИСКА
  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _message = 'Введите название книги или автора для поиска.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = 'Ищем книги...';
    });

    try {
      final results = await BookApiService.searchBooks(query);

      setState(() {
        _searchResults = results;
        _isLoading = false;
        if (results.isEmpty) {
          _message = 'По вашему запросу ничего не найдено.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Произошла ошибка при поиске. Проверьте соединение.';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск по API'),
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Название, автор или ISBN',
                hintText: 'Начните ввод...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: colorScheme.secondary, width: 2.0),
                ),
              ),
              onSubmitted: _performSearch, // Запуск поиска по Enter
            ),
          ),

          // Индикатор загрузки или сообщение
          if (_isLoading)
            Center(child: CircularProgressIndicator(color: colorScheme.primary))
          else if (_searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_message, style: TextStyle(color: colorScheme.secondary)),
            ),

          // Список результатов
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return BookCard(
                  book: book,
                  isRead: false,
                  // При нажатии на карточку в поиске - добавляем книгу
                  onTap: () {
                    // Вызываем callback для добавления книги в список
                    widget.onBookSelected(book);
                    // Закрываем текущий экран поиска
                    Navigator.of(context).pop();
                    // Если нужно, закроем и модальное окно выбора, если оно осталось
                    // (для этого потребуется немного доработать _addBook в main.dart)

                    // Показываем подтверждение
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Книга "${book.title}" добавлена в вишлист!')),
                    );
                  },
                  // Кнопка для быстрого добавления
                  actionButton: Icon(
                    Icons.add_circle,
                    color: colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}