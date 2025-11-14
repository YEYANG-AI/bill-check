import 'dart:convert';
import 'package:billcheck/model/history_model.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  final HiveDatabase _db = HiveDatabase.instance;

  Future<HistoryResponse> fetchOrderHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = _db.loadToken();
      final response = await http.get(
        Uri.parse(ApiPath.washingMachines), // Adjust endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return HistoryResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load order history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching order history: $e');
    }
  }

  // You can add more methods for filtering, searching, etc.
}
