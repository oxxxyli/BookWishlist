import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart'; // Используем модель Book для удобства

class BookApiService {
  // 🔑 НОВЫЙ МЕТОД: Поиск книг по запросу
  static Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final encodedQuery = Uri.encodeQueryComponent(query);
    // Увеличим количество результатов до 10
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$encodedQuery&maxResults=10');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['totalItems'] == 0 || data['items'] == null) {
          return [];
        }

        List<Book> foundBooks = [];

        for (var item in data['items']) {
          final info = item['volumeInfo'];

          final title = info['title'] ?? 'Название не указано';
          final authors = info['authors'];
          final author = authors != null && authors.isNotEmpty ? authors.join(', ') : 'Неизвестный автор';

          final description = info['description'] ?? 'Описание не найдено.';

          String? coverUrl;
          final imageLinks = info['imageLinks'];
          if (imageLinks != null) {
            // Предпочитаем medium или thumbnail
            coverUrl = imageLinks['medium'] ?? imageLinks['thumbnail'];

            // Замена http на https
            if (coverUrl != null && coverUrl!.startsWith('http://')) {
              coverUrl = coverUrl!.replaceFirst('http://', 'https://');
            }
          }

          foundBooks.add(
            Book(
              title: title,
              author: author,
              description: description,
              coverUrl: coverUrl,
            ),
          );
        }

        return foundBooks;
      } else {
        throw Exception('Ошибка API: ${response.statusCode}');
      }
    } catch (e) {
      // Для отладки можно вывести ошибку, но пользователю вернем пустой список
      print('Ошибка сети/парсинга при поиске: $e');
      return [];
    }
  }

  static Future<Map<String, String?>> fetchBookDetails(String title) async {
    final encodedTitle = Uri.encodeQueryComponent(title);
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$encodedTitle&maxResults=1');

    String? description;
    String? coverUrl;

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0 && data['items'] != null) {
        final item = data['items'][0]['volumeInfo'];
        description = item['description'] ?? 'Описание не найдено.';
        final imageLinks = item['imageLinks'];
        if (imageLinks != null) {
          coverUrl = imageLinks['large'] ?? imageLinks['medium'] ?? imageLinks['thumbnail'];
          if (coverUrl != null && coverUrl!.startsWith('http://')) {
            coverUrl = coverUrl!.replaceFirst('http://', 'https://');
          }
        }
      } else {
        description = 'Книга не найдена в Google Books.';
      }
    } else {
      description = 'Ошибка API: ${response.statusCode}';
    }
    return {'description': description, 'coverUrl': coverUrl};
  }
}