import 'package:flutter/material.dart';
import 'screens/wishlist_screen.dart';
import 'screens/read_screen.dart';
import 'models/book.dart';
import 'widgets/book_form.dart';

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
      home: const HomePage(), // Главный Stateful виджет
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Индекс для BottomNavigationBar

  // 📚 Хранение состояния: Список всех книг
  List<Book> _allBooks = [
    Book(title: 'Имя ветра', author: 'Патрик Ротфусс', isRead: false),
    Book(title: 'Гордость и предубеждение', author: 'Джейн Остин', isRead: true),
  ];

  // Методы для изменения состояния:

  // 1. Добавление новой книги
  void _addBook(String title, String author) {
    setState(() {
      _allBooks.add(Book(title: title, author: author));
    });
  }

  // 2. Изменение статуса на "Прочитано"
  void _markAsRead(Book book) {
    final bookIndex = _allBooks.indexOf(book);
    if (bookIndex != -1) {
      setState(() {
        _allBooks[bookIndex] = book.copyWith(isRead: true);
      });
    }
  }

  // 3. Функция, которая вызывается при нажатии на элемент BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔑 ИСПРАВЛЕНИЕ: Функция для показа модального окна теперь является методом класса
  void _showAddBookModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BookForm(onAdd: _addBook), // Передаем функцию добавления в форму
        );
      },
    );
  }

  // Списки, отфильтрованные по статусу
  List<Book> get _wishlistBooks => _allBooks.where((book) => !book.isRead).toList();
  List<Book> get _readBooks => _allBooks.where((book) => book.isRead).toList();


  @override
  Widget build(BuildContext context) {
    // Список экранов для BottomNavigationBar
    final List<Widget> _widgetOptions = <Widget>[
      WishlistScreen(
        books: _wishlistBooks,
        onMarkAsRead: _markAsRead,
        onAddTapped: _showAddBookModal, // Теперь метод _showAddBookModal доступен
      ),
      ReadScreen(books: _readBooks),
    ];

    // Локальная функция _showAddBookModal удалена из метода build()

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Отображаем выбранный экран
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