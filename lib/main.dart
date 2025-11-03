import 'package:flutter/material.dart';
import 'dart:convert'; // Для кодирования/декодирования JSON
import 'package:shared_preferences/shared_preferences.dart'; // Для хранения
import 'screens/wishlist_screen.dart';
import 'screens/read_screen.dart';
import 'models/book.dart';
import 'widgets/book_form.dart';
import 'services/book_api_service.dart'; // <-- Импорт API

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
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
  List<Book> _allBooks = []; // Начинаем с пустого списка, чтобы загрузить данные

  // 🔑 МЕТОД: Сохранение данных
  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    // Преобразуем список объектов Book в список JSON-строк
    final List<String> bookStrings = _allBooks
        .map((book) => jsonEncode({
      'title': book.title,
      'author': book.author,
      'isRead': book.isRead,
      'description': book.description, // <-- Сохраняем описание
    }))
        .toList();
    await prefs.setStringList('books_list', bookStrings);
  }

  // 🔑 МЕТОД: Загрузка данных
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
          description: map['description'] as String?, // <-- Загружаем описание
        );
      }).toList();

      setState(() {
        _allBooks = loadedBooks;
      });
    } else {
      // Инициализация стартовыми данными, если ничего не сохранено
      setState(() {
        _allBooks = [
          Book(title: 'Имя ветра', author: 'Патрик Ротфусс', isRead: false),
          Book(title: 'Гордость и предубеждение', author: 'Джейн Остин', isRead: true),
        ];
      });
      _saveBooks();
    }
  }

  // Вызываем загрузку при инициализации виджета
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // 1. Обновленный _addBook с вызовом API
  void _addBook(String title, String author) async {
    // 🔑 ЛОГИКА API: Запускаем поиск описания
    final description = await BookApiService.fetchDescription(title);

    setState(() {
      _allBooks.add(Book(
        title: title,
        author: author,
        description: description, // Используем результат API
      ));
    });
    _saveBooks(); // Сохранение после добавления
  }

  // 2. Обновленный _markAsRead
  void _markAsRead(Book book) {
    final bookIndex = _allBooks.indexOf(book);
    if (bookIndex != -1) {
      setState(() {
        _allBooks[bookIndex] = book.copyWith(isRead: true);
      });
      _saveBooks(); // Сохранение после изменения статуса
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔑 _showAddBookModal: (перенесена в класс для исправления ошибки ЛР5)
  void _showAddBookModal() {
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

  List<Book> get _wishlistBooks => _allBooks.where((book) => !book.isRead).toList();
  List<Book> get _readBooks => _allBooks.where((book) => book.isRead).toList();


  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      WishlistScreen(
        books: _wishlistBooks,
        onMarkAsRead: _markAsRead,
        onAddTapped: _showAddBookModal,
      ),
      ReadScreen(books: _readBooks),
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
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}