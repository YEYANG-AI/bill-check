class Customer {
  final int id;
  final String name;
  final String surname;
  final String tel;
  final String email;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.surname,
    required this.tel,
    required this.email,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      tel: json['tel'],
      email: json['email'],
      address: json['address'],
    );
  }
}
