import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class DictionaryRemoteDataSource {
  Future<Map<String, String>> fetchWordMeaning(String word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final http.Client client;

  DictionaryRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, String>> fetchWordMeaning(String word) async {
    try {
      final cleanWord =
          word.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();

      if (cleanWord.isEmpty) {
        throw Exception('Invalid word');
      }

      final response = await client.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$cleanWord'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final wordData = data[0];
          final meanings = wordData['meanings'] as List;

          if (meanings.isNotEmpty) {
            final firstMeaning = meanings[0];
            final partOfSpeech = firstMeaning['partOfSpeech'] as String? ?? '';
            final definitions = firstMeaning['definitions'] as List;

            if (definitions.isNotEmpty) {
              final definition = definitions[0]['definition'] as String;
              final example = definitions[0]['example'] as String? ?? '';

              return {
                'word': wordData['word'] as String,
                'partOfSpeech': partOfSpeech,
                'definition': definition,
                'example': example,
              };
            }
          }
        }

        throw Exception('No definition found');
      } else if (response.statusCode == 404) {
        throw Exception('Word not found');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch word meaning: $e');
    }
  }
}
