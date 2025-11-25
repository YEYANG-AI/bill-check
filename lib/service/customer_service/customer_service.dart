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
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as List;
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<void> addCustomer(
    String name,
    String surname,
    String phone,
    String email,
    String address,
  ) async {
    final url = Uri.parse(ApiPath.customer);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_db.loadToken()}',
      },
      body: jsonEncode({
        'name': name,
        'tel': phone,
        'email': email,
        'address': address,
        'surname': surname,
      }),
    );

    print('response.body: ${response.body}');
    print('response.statusCode: ${response.statusCode}');

    final decoded = json.decode(response.body);

    if (response.statusCode == 201) {
      print('Customer added successfully');
    } else {
      final message =
          decoded['message'] ?? 'Failed to add customer. Please try again.';
      throw Exception(message);
    }
  }

  Future<void> deleteCustomer(int id) async {
    final url = Uri.parse("${ApiPath.customer}/$id");
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_db.loadToken()}',
      },
    );
    print("DELETE URL: $url");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 204) {
      print('Customer deleted successfully');
    } else {
      throw Exception('Failed to delete customer');
    }
  }

  Future<void> updateCustomer(
    int id,
    String name,
    String surname,
    String phone,
    String email,
    String address,
  ) async {
    final url = Uri.parse("${ApiPath.customer}/$id");
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_db.loadToken()}',
      },
      body: jsonEncode({
        'name': name,
        'tel': phone,
        'email': email,
        'address': address,
        'surname': surname,
      }),
    );

    if (response.statusCode == 200) {
      print('Customer updated successfully');
    } else {
      throw Exception('Failed to update customer');
    }
  }
}
