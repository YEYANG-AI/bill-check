import 'dart:convert';
import 'package:billcheck/model/laundry_model.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final HiveDatabase _db = HiveDatabase.instance;
  Future<bool> createOrder(Order order) async {
    try {
      final token = _db.loadToken();
      final response = await http.post(
        Uri.parse(ApiPath.washingMachines), // Adjust endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }
}
