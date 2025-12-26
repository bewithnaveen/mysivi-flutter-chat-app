import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

abstract class MessageRemoteDataSource {
  Future<String> fetchRandomMessage();
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;
  
  // Multiple API endpoints as specified in requirements
  final List<String> apiEndpoints = [
    'https://dummyjson.com/comments?limit=1',
    'https://jsonplaceholder.typicode.com/comments?postId=1',
    'https://api.quotable.io/random',
  ];

  MessageRemoteDataSourceImpl(this.client);

  @override
  Future<String> fetchRandomMessage() async {
    try {
      // Randomly select an API endpoint
      final random = Random();
      final selectedEndpoint = apiEndpoints[random.nextInt(apiEndpoints.length)];
      
      final response = await client.get(
        Uri.parse(selectedEndpoint),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Parse based on different API structures
        if (selectedEndpoint.contains('dummyjson')) {
          final comments = data['comments'] as List;
          if (comments.isNotEmpty) {
            return comments[0]['body'] as String;
          }
        } else if (selectedEndpoint.contains('jsonplaceholder')) {
          if (data is List && data.isNotEmpty) {
            // Get random comment from the list
            final randomIndex = random.nextInt(data.length);
            return data[randomIndex]['body'] as String;
          }
        } else if (selectedEndpoint.contains('quotable')) {
          return data['content'] as String;
        }
        
        throw Exception('Failed to parse message from API');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch message: $e');
    }
  }
}
