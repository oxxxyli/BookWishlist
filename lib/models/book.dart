class Book {
  final String title;
  final String author;
  final bool isRead;

  Book({
    required this.title,
    required this.author,
    this.isRead = false,
  });

  // Метод для создания копии книги с измененным статусом (для "Прочитано")
  Book copyWith({
    bool? isRead,
  }) {
    return Book(
      title: title,
      author: author,
      isRead: isRead ?? this.isRead,
    );
  }
}