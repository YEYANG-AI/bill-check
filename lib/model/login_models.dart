class User {
  final int id;
  final String name;
  final String email;
  final String? userNo;
  final String? surname;
  final String? tel;
  final String accessToken;
  final String? verifyOtp;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.userNo,
    this.surname,
    this.tel,
    this.accessToken = '',
    this.verifyOtp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userNo: json['user_no'],
      surname: json['surname'],
      tel: json['tel'],
      accessToken: json['access_token'],
      verifyOtp: json['verify_otp'],
    );
  }

  User copyWith({String? accessToken}) {
    return User(
      id: id,
      name: name,
      email: email,
      userNo: userNo,
      surname: surname,
      tel: tel,
      accessToken: accessToken ?? this.accessToken,
      verifyOtp: verifyOtp,
    );
  }
}
