import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'screens/wishlist_screen.dart';
import 'screens/read_screen.dart';
import 'screens/book_search_screen.dart';
import 'models/book.dart';
import 'widgets/book_form.dart';
import 'widgets/edit_book_form.dart';
import 'widgets/add_method_selector.dart';
import 'services/book_api_service.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BookWishlist',
      debugShowCheckedModeBanner: false,

      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode,

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Book> _allBooks = [];

  // --- Методы сохранения и загрузки данных ---

  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookStrings = _allBooks
        .map((book) => jsonEncode({
      'title': book.title,
      'author': book.author,
      'isRead': book.isRead,
      'description': book.description,
      'coverUrl': book.coverUrl,
    }))
        .toList();
    await prefs.setStringList('books_list', bookStrings);
  }

  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookStrings = prefs.getStringList('books_list');

    if (bookStrings != null) {
      final List<Book> loadedBooks = bookStrings.map((str) {
        final Map<String, dynamic> map = jsonDecode(str);
        return Book(
          title: map['title'] as String,
          author: map['author'] as String,
          isRead: map['isRead'] as bool,
          description: map['description'] as String?,
          coverUrl: map['coverUrl'] as String?,
        );
      }).toList();

      setState(() {
        _allBooks = loadedBooks;
      });
    } else {
      // Инициализация стартовыми данными
      setState(() {
        _allBooks = [
          Book(title: 'Имя ветра', author: 'Патрик Ротфусс', isRead: false, description: 'Начальное описание.', coverUrl: null),
          Book(title: 'Гордость и предубеждение', author: 'Джейн Остин', isRead: true, description: 'Начальное описание.', coverUrl: null),
        ];
      });
      _saveBooks();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // --- Методы изменения состояния ---

  // Добавление книги вручную (с запросом деталей)
  void _addBook(String title, String author) async {
    final details = await BookApiService.fetchBookDetails(title);

    setState(() {
      _allBooks.add(Book(
        title: title,
        author: author,
        description: details['description'],
        coverUrl: details['coverUrl'],
      ));
    });
    _saveBooks();
  }

  // Добавление книги напрямую (с экрана поиска)
  void _addBookDirectly(Book book) {
    setState(() {
      _allBooks.add(book);
    });
    _saveBooks();
  }

  void _markAsRead(Book book) {
    final bookIndex = _allBooks.indexOf(book);
    if (bookIndex != -1) {
      setState(() {
        _allBooks[bookIndex] = book.copyWith(isRead: true);
      });
      _saveBooks();
    }
  }

  void _updateBook(Book oldBook, String newTitle, String newAuthor) async {
    final bookIndex = _allBooks.indexOf(oldBook);

    if (bookIndex != -1) {
      String? description = oldBook.description;
      String? coverUrl = oldBook.coverUrl;

      if (newTitle.trim().toLowerCase() != oldBook.title.trim().toLowerCase()) {
        final details = await BookApiService.fetchBookDetails(newTitle);
        description = details['description'];
        coverUrl = details['coverUrl'];
      }

      setState(() {
        _allBooks[bookIndex] = Book(
          title: newTitle,
          author: newAuthor,
          isRead: oldBook.isRead,
          description: description,
          coverUrl: coverUrl,
        );
      });
      _saveBooks();
    }
  }

  // 🔑 МЕТОД: Удаление книги (НОВОЕ)
  void _deleteBook(Book book) {
    setState(() {
      _allBooks.remove(book);
    });
    _saveBooks();
    // Возврат назад с детального экрана после успешного удаления
    Navigator.of(context).pop();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showManualBookForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BookForm(onAdd: _addBook),
        );
      },
    );
  }

  void _showAddBookModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddMethodSelector(
          onManualAdd: () {
            Navigator.of(context).pop();
            _showManualBookForm();
          },
          onApiSearch: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => BookSearchScreen(
                  onBookSelected: _addBookDirectly,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditBookModal(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditBookForm(
            initialBook: book,
            onUpdate: _updateBook,
          ),
        );
      },
    );
  }

  List<Book> get _wishlistBooks => _allBooks.where((book) => !book.isRead).toList();
  List<Book> get _readBooks => _allBooks.where((book) => book.isRead).toList();


  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      WishlistScreen(
        books: _wishlistBooks,
        onMarkAsRead: _markAsRead,
        onAddTapped: _showAddBookModal,
        onEditTapped: _showEditBookModal,
        onDeleteTapped: _deleteBook, // <-- ПЕРЕДАЧА ФУНКЦИИ УДАЛЕНИЯ
      ),
      ReadScreen(
        books: _readBooks,
        onEditTapped: _showEditBookModal,
        onDeleteTapped: _deleteBook, // <-- ПЕРЕДАЧА ФУНКЦИИ УДАЛЕНИЯ
      ),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Вишлист',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Прочитано',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}