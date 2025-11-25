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

  Future<void> addItem(String name, int price) async {
    try {
      final url = Uri.parse(ApiPath.clothes);
      final token = _db.loadToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'price': price}),
      );

      if (response.statusCode == 201) {
        print('Item added successfully');
      } else {
        throw Exception('Failed to add item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item: $e');
      throw Exception('Failed to add item to server');
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      final url = Uri.parse("${ApiPath.clothes}/$id");
      final token = _db.loadToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully');
      } else {
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting item: $e');
      throw Exception('Failed to delete item from server');
    }
  }

  Future<void> updateItem(int id, String name, int price) async {
    try {
      final url = Uri.parse("${ApiPath.clothes}/$id");
      final token = _db.loadToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'price': price}),
      );

      if (response.statusCode == 200) {
        print('Item updated successfully');
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating item: $e');
      throw Exception('Failed to update item on server');
    }
  }

  // Add to clothes_service.dart
  Future<Map<String, dynamic>> getClothesById(int id) async {
    try {
      final url = Uri.parse("${ApiPath.clothes}/$id");
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

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return Map<String, dynamic>.from(body['data'] ?? {});
      } else {
        throw Exception('Failed to load clothes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clothes by ID: $e');
      throw Exception('Failed to load clothes from server');
    }
  }

  Future<Map<int, String>> getClothesNamesByIds(List<int> clothesIds) async {
    final Map<int, String> clothesNames = {};

    for (final id in clothesIds) {
      try {
        final clothes = await getClothesById(id);
        if (clothes['name'] != null) {
          clothesNames[id] = clothes['name'] as String;
        }
      } catch (e) {
        print('Error fetching clothes name for ID $id: $e');
        clothesNames[id] = 'ບໍ່ຮູ້ຊື່ສິນຄ້າ';
      }
    }

    return clothesNames;
  }
}
