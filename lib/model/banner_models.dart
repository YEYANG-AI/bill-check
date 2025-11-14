class BannerModels {
  final int id;
  final String fileBanner;
  final String link;
  final String orderBy;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String imageUrl;

  BannerModels({
    required this.id,
    required this.fileBanner,
    required this.link,
    required this.orderBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.imageUrl,
  });
  factory BannerModels.fromJson(Map<String, dynamic> json) {
    return BannerModels(
      id: json['id'],
      fileBanner: json['file_banner'],
      link: json['link'],
      orderBy: json['order_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      imageUrl: json['image_url'],
    );
  }
}
