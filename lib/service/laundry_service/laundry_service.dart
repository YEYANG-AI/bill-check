import 'dart:convert';
import 'package:billcheck/model/history_model.dart';
import 'package:billcheck/model/laundry_model.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final HiveDatabase _db = HiveDatabase.instance;

  Future<int?> createOrder(Order order) async {
    // Changed to return order ID
    try {
      final token = _db.loadToken();
      final response = await http.post(
        Uri.parse(ApiPath.washingMachines),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 201) {
        print("Order created successfully ${response.body}");
        final responseData = jsonDecode(response.body);
        // Extract order ID from response
        final orderId = responseData['data']['id'];
        return orderId;
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // Add method to get order by ID
  Future<HistoryOrder> getOrderById(int orderId) async {
    try {
      final token = _db.loadToken();
      final response = await http.get(
        Uri.parse('${ApiPath.washingMachines}/$orderId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return HistoryOrder.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to fetch order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }
}
