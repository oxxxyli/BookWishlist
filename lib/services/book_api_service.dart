import 'dart:convert';
import 'package:http/http.dart' as http;

class BookApiService {
  // 🔑 API: Поиск по названию книги
  static Future<String?> fetchDescription(String title) async {
    // Кодируем название для безопасного URL-запроса
    final encodedTitle = Uri.encodeQueryComponent(title);

    // Google Books API URL для поиска одной книги
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$encodedTitle&maxResults=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Проверяем, есть ли результаты и элементы
        if (data['totalItems'] > 0 && data['items'] != null) {
          final item = data['items'][0]['volumeInfo'];
          // Возвращаем краткое описание, если оно есть
          return item['description'] ?? 'Описание не найдено.';
        }
        return 'Книга не найдена в Google Books.';
      } else {
        return 'Ошибка API: ${response.statusCode}';
      }
    } catch (e) {
      // Ошибка сети или другая ошибка
      return 'Ошибка сети: $e';
    }
  }
}