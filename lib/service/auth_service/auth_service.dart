import 'dart:convert';
import 'package:billcheck/model/user_models.dart';
import 'package:billcheck/service/api/api_path.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<User?> login(String email, String password) async {
    final url = Uri.parse(ApiPath.login);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userJson = data['data']['user'];
      final token = data['data']['access_token'];
      return User.fromJson(userJson).copyWith(accessToken: token);
    } else if (response.statusCode == 401) {
      return null; // invalid credentials
    } else {
      throw Exception(
        'Login failed: ${response.statusCode} - ${data['message']}',
      );
    }
  }
}
