import 'dart:convert';

import 'package:billcheck/model/banner_models.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;

class BannerService {
  final _db = HiveDatabase.instance;
  Future<List<BannerModels>> fetchCustomers() async {
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
      return data.map((json) => BannerModels.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
