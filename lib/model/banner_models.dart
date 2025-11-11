class BannerModels {
  final int id;
  final String file_banner;
  final String description;

  BannerModels({
    required this.id,
    required this.file_banner,
    required this.description,
  });
  factory BannerModels.fromJson(Map<String, dynamic> json) {
    return BannerModels(
      id: json['id'],
      file_banner: json['file_banner'],
      description: json['description'],
    );
  }
}
