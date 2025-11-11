import 'dart:convert';
import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final HiveDatabase _db = HiveDatabase.instance;
  Future<List<Customer>> fetchCustomers() async {
    final url = Uri.parse(ApiPath.customer);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_db.loadToken()}',
      },
    );
    print('token: ${_db.loadToken()}');
    print('response.body: ${url}');
    print('response.statusCode: ${response.statusCode}');
    print('response: $response');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as List;
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<void> addCustomer(String name, String phone) async {
    final url = Uri.parse(ApiPath.customer);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_db.loadToken()}',
      },
      body: jsonEncode({'name': name, 'phone': phone}),
    );
    print('token: ${_db.loadToken()}');
    print('response.body: ${url}');
    print('response.statusCode: ${response.statusCode}');
    print('response: $response');
    if (response.statusCode == 200) {
      print('Customer added successfully');
    } else {
      throw Exception('Failed to add customer');
    }
  }
}
