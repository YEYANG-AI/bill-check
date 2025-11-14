import 'dart:convert';

import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class BannerService {
  final _db = HiveDatabase.instance;
  Future<List<Map<String, dynamic>>> fetchBanners() async {
    final url = Uri.parse(ApiPath.banner);
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
    print('token: $token');
    print('response.body: ${url}');
    print('response.statusCode: ${response.statusCode}');
    print('response: $response');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] as List;
      return data.map((json) {
        return Map<String, dynamic>.from(json);
      }).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
