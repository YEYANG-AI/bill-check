class ClothesModel {
  final String id;
  final String name;
  final String price;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ClothesModel({
    required this.id,
    required this.name,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
