// services/user_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:billcheck/service/api/api_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  // Upload image and get imageUrl
  // services/user_service.dart
  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse(ApiPath.uploadImage);
    final token = _db.loadToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    print('📤 Uploading image: ${imageFile.path}');

    // Check file size (optional - adjust as needed)
    final fileSize = await imageFile.length();
    final maxSize = 5 * 1024 * 1024; // 5MB
    if (fileSize > maxSize) {
      throw Exception('File size too large. Maximum size is 5MB');
    }

    // Check file extension
    String filePath = imageFile.path.toLowerCase();
    if (!filePath.endsWith('.png') &&
        !filePath.endsWith('.jpg') &&
        !filePath.endsWith('.jpeg') &&
        !filePath.endsWith('.gif') &&
        !filePath.endsWith('.webp')) {
      throw Exception(
        'Invalid file type. Please use PNG, JPG, JPEG, GIF, or WEBP',
      );
    }

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add image file with correct content type
      String? mimeType;
      if (filePath.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (filePath.endsWith('.gif')) {
        mimeType = 'image/gif';
      } else if (filePath.endsWith('.webp')) {
        mimeType = 'image/webp';
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Field name from your API
          imageFile.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print('📸 Upload Image Response: $jsonResponse');

      if (response.statusCode == 201) {
        final imageUrl = jsonResponse['data']['imageUrl'];
        print('✅ Image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: ${jsonResponse['message']}');
      }
    } catch (e) {
      print('❌ Upload error: $e');
      throw Exception('Upload failed: $e');
    }
  }

  // Update user profile with image
  Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? surname,
    String? email,
    String? tel,
    String? image, // This should be the imageUrl from uploadImage
  }) async {
    final url = Uri.parse(ApiPath.updateProfile);
    final token = _db.loadToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final updateData = {
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (email != null) 'email': email,
      if (tel != null) 'tel': tel,
      if (image != null) 'image': image, // Send the imageUrl here
    };

    print('🔄 Updating profile with: $updateData');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updateData),
    );

    print('📡 Update Profile Response: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode}');
    }
  }

  // Combined method: Upload image and update profile
  Future<Map<String, dynamic>> updateProfileWithImage({
    required File imageFile,
    String? name,
    String? surname,
    String? email,
    String? tel,
  }) async {
    try {
      // 1. First upload the image
      final imageUrl = await uploadImage(imageFile);

      // 2. Then update profile with the imageUrl
      final updatedProfile = await updateUserProfile(
        name: name,
        surname: surname,
        email: email,
        tel: tel,
        image: imageUrl, // Use the uploaded image URL
      );

      return updatedProfile;
    } catch (e) {
      throw Exception('Failed to update profile with image: $e');
    }
  }

  // services/user_service.dart - Fixed changePassword method
  Future<void> changePassword({
    required String newPassword,
    required String confirmPassword,
    required String userId,
  }) async {
    final url = Uri.parse('${ApiPath.changePassword}/$userId');
    final token = _db.loadToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Use the exact field names that the API expects
    final passwordData = {
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };

    print('🔒 Changing password for user: $userId');
    print('🌐 URL: $url');
    print('📦 Request data: $passwordData');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(passwordData),
    );

    final responseBody = json.decode(response.body);
    print('📡 Change Password Response: $responseBody');

    if (response.statusCode == 200) {
      print('✅ Password changed successfully');
    } else if (response.statusCode == 422) {
      // Handle validation errors specifically
      final errors = responseBody['errors'];
      if (errors != null) {
        final errorMessages = [];
        errors.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.cast<String>());
          }
        });
        throw Exception(errorMessages.join(', '));
      } else {
        throw Exception(responseBody['message'] ?? 'Validation failed');
      }
    } else {
      throw Exception(
        responseBody['message'] ??
            'Failed to change password: ${response.statusCode}',
      );
    }
  }
}
