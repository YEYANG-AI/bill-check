// services/user_service.dart
import 'dart:convert';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class UserService {
  final _db = HiveDatabase.instance;

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final url = Uri.parse(ApiPath.getProfile);
    final token = _db.loadToken();

    print('🔑 UserService: Token available: ${token != null}');
    print('🌐 UserService: Fetching from: $url');

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

    print('📡 UserService: Response status: ${response.statusCode}');
    print('📦 UserService: Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print('✅ UserService: API response: $body');

      // Check the structure of your response
      if (body['data'] != null) {
        return body['data'];
      } else {
        throw Exception('No data in response');
      }
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> updateData,
  ) async {
    final url = Uri.parse(ApiPath.updateProfile); // Your update endpoint
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
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Failed to update user profile');
    }
  }
}
