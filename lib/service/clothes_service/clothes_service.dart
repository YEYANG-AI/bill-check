// clothes_service.dart
import 'dart:convert';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class ClothesService {
  final HiveDatabase _db = HiveDatabase.instance;

  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final url = Uri.parse(ApiPath.clothes);
      final token = _db.loadToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Clothes API Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] as List;
        print('Fetched ${data.length} items from API');

        return data.map((json) {
          return Map<String, dynamic>.from(json);
        }).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clothes: $e');
      throw Exception('Failed to load items from server');
    }
  }
}
