import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

// Преобразуем в StatefulWidget
class ReadScreen extends StatefulWidget {
  final List<Book> books;
  final Function(Book) onEditTapped;
  final Function(Book) onDeleteTapped;

  const ReadScreen({
    super.key,
    required this.books,
    required this.onEditTapped,
    required this.onDeleteTapped,
  });

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // 🔑 Состояние для поискового запроса

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Обновляем состояние запроса при изменении текста в поле поиска
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // 🔑 Метод для фильтрации списка
  List<Book> get _filteredBooks {
    if (_searchQuery.isEmpty) {
      return widget.books;
    }
    return widget.books.where((book) {
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      return titleLower.contains(_searchQuery) ||
          authorLower.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredList = _filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Прочитано'),
        // 🔑 Добавляем поле поиска прямо в AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Поиск по названию или автору...',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
      body: filteredList.isEmpty && _searchQuery.isNotEmpty
          ? Center(
        child: Text(
          'Ничего не найдено по запросу "$_searchController.text"',
          style: TextStyle(color: colorScheme.secondary),
        ),
      )
          : filteredList.isEmpty && _searchQuery.isEmpty
          ? Center(
        child: Text(
          'Вы пока ничего не прочитали!',
          style: TextStyle(color: colorScheme.secondary),
        ),
      )
          : ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final book = filteredList[index];

          return BookCard(
            book: book,
            isRead: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => BookDetailScreen(
                    book: book,
                    onEditTapped: widget.onEditTapped,
                    onDeleteTapped: widget.onDeleteTapped,
                  ),
                ),
              );
            },
            actionButton: Icon(
              Icons.menu_book,
              color: colorScheme.secondary.withOpacity(0.7),
            ),
          );
        },
      ),
    );
  }
}