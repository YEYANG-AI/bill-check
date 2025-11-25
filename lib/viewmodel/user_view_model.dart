// viewmodels/user_view_model.dart
import 'package:billcheck/model/user_model.dart';
import 'package:billcheck/service/user_service/user_service.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  bool _isLoading = false;
  String _error = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get hasUser => _user != null;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    print('🔄 UserViewModel: Starting to load user profile...');

    try {
      final userData = await _userService.fetchUserProfile();
      print('✅ UserViewModel: Received user data: $userData');

      _user = UserModel.fromJson(userData);
      print('✅ UserViewModel: User model created: ${_user?.toJson()}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      print('❌ UserViewModel: Error loading user profile: $e');
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? surname,
    String? email,
    String? tel,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final updateData = {
        if (name != null) 'name': name,
        if (surname != null) 'surname': surname,
        if (email != null) 'email': email,
        if (tel != null) 'tel': tel,
      };

      final updatedData = await _userService.updateUserProfile(updateData);
      _user = UserModel.fromJson(updatedData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  Future<void> reload() async {
    await loadUserProfile();
  }
}
