class Book {
  final String title;
  final String author;
  final bool isRead;
  final String? description; // поле для описания

  Book({
    required this.title,
    required this.author,
    this.isRead = false,
    this.description, // принимается описание
  });

  // Метод для создания копии книги с измененным статусом
  Book copyWith({
    bool? isRead,
    String? description, // параметр description для копирования
  }) {
    return Book(
      title: title,
      author: author,
      isRead: isRead ?? this.isRead,
      description: description ?? this.description, // Сохраняем новое/старое описание
    );
  }
}