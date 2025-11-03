class Book {
  final String title;
  final String author;
  final bool isRead;
  final String? description;
  final String? coverUrl; // <-- Новое поле для URL обложки

  Book({
    required this.title,
    required this.author,
    this.isRead = false,
    this.description,
    this.coverUrl, // <-- Принимаем URL обложки
  });

  // Метод для создания копии книги с измененным статусом
  Book copyWith({
    bool? isRead,
    String? description,
    String? coverUrl, // <-- Добавляем в copyWith
  }) {
    return Book(
      title: title,
      author: author,
      isRead: isRead ?? this.isRead,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl, // Сохраняем новое/старое URL
    );
  }
}