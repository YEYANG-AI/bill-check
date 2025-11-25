import 'package:billcheck/model/login_models.dart';
import 'package:billcheck/service/auth_service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../service/hive/hive_database.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  User? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;

  Future<void> checkLoginStatus() async {
    final userData = HiveDatabase.instance.loadUser();
    if (userData.isNotEmpty) {
      _user = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        accessToken: userData['token'],
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);
      if (result != null) {
        _user = result;

        // Save user token locally in Hive
        // await HiveDatabase.instance.saveToken(result.accessToken);
        await HiveDatabase.instance.userBox.put('user', {
          'id': result.id,
          'name': result.name,
          'email': result.email,
          'token': result.accessToken,
        });
        await HiveDatabase.instance.saveToken(result.accessToken);
      } else {
        _error = 'ອີເມວ ຫຼື ລະຫັດຜ່ານຜິດ';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() async {
    _user = null;
    await HiveDatabase.instance.clearUser();
    notifyListeners();
  }
}
