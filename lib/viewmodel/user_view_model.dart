// viewmodels/user_view_model.dart
import 'dart:io';

import 'package:billcheck/model/user_model.dart';
import 'package:billcheck/service/user_service/user_service.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  bool _isLoading = false;
  String _error = '';
  bool _isUploading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get hasUser => _user != null;
  bool get isUploading => _isUploading;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = '';
    // notifyListeners();

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
    String? image,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final updatedData = await _userService.updateUserProfile(
        name: name,
        surname: surname,
        email: email,
        tel: tel,
        image: image,
      );
      _user = UserModel.fromJson(updatedData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Upload image and update profile
  Future<void> updateProfileImage(File imageFile) async {
    _isUploading = true;
    _error = '';
    notifyListeners();

    try {
      final updatedData = await _userService.updateProfileWithImage(
        imageFile: imageFile,
        name: _user?.name,
        surname: _user?.surname,
        email: _user?.email,
        tel: _user?.tel,
      );
      _user = UserModel.fromJson(updatedData);
      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isUploading = false;
      notifyListeners();
    }
  }

  // Only upload image without updating other profile data
  Future<String?> uploadImageOnly(File imageFile) async {
    _isUploading = true;
    _error = '';
    notifyListeners();

    try {
      final imageUrl = await _userService.uploadImage(imageFile);

      if (_user != null) {
        final updatedUser = UserModel(
          id: _user!.id,
          userNo: _user!.userNo,
          name: _user!.name,
          surname: _user!.surname,
          email: _user!.email,
          tel: _user!.tel,
          createdAt: _user!.createdAt,
          updatedAt: _user!.updatedAt,
          profile: UserProfile(
            id: _user!.profile?.id ?? 0,
            image: imageUrl,
            imageUrl: imageUrl,
            userId: _user!.id,
            createdAt: _user!.profile?.createdAt,
            updatedAt: _user!.profile?.updatedAt,
          ),
          roles: _user!.roles,
          permissions: _user!.permissions,
        );

        _user = updatedUser;
      }

      _isUploading = false;
      notifyListeners();
      return imageUrl; // Return uploaded ID
    } catch (e) {
      _error = e.toString();
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }

  // Change password
  Future<void> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _userService.changePassword(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        userId: _user!.id.toString(),
      );
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
