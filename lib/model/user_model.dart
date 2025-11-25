// models/user_model.dart
class UserModel {
  final int id;
  final String userNo;
  final String name;
  final String surname;
  final String email;
  final String tel;
  final String createdAt;
  final String updatedAt;
  final UserProfile profile;
  final List<UserRole> roles;
  final List<dynamic> permissions;

  UserModel({
    required this.id,
    required this.userNo,
    required this.name,
    required this.surname,
    required this.email,
    required this.tel,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.roles,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userNo: json['user_no'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      tel: json['tel'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      roles: (json['roles'] as List? ?? [])
          .map((role) => UserRole.fromJson(role))
          .toList(),
      permissions: json['permissions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_no': userNo,
      'name': name,
      'surname': surname,
      'email': email,
      'tel': tel,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile': profile.toJson(),
      'roles': roles.map((role) => role.toJson()).toList(),
      'permissions': permissions,
    };
  }

  String get fullName => '$name $surname';
  String get displayName => '$name $surname'.trim();
}

class UserProfile {
  final int id;
  final String image;
  final String imageUrl;
  final int userId;
  final String? createdAt;
  final String? updatedAt;

  UserProfile({
    required this.id,
    required this.image,
    required this.imageUrl,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'image_url': imageUrl,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class UserRole {
  final int id;
  final String name;

  UserRole({required this.id, required this.name});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
