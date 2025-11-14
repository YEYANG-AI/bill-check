import 'package:billcheck/service/banners_service/banner_service.dart';
import 'package:flutter/material.dart';

class BannerViewModel extends ChangeNotifier {
  final BannerService _bannerService = BannerService();

  List<Map<String, dynamic>> _banners = [];
  bool _isLoading = false;
  String _error = '';

  List<Map<String, dynamic>> get banners => _banners;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get hasBanners => _banners.isNotEmpty;

  Future<void> loadBanner() async {
    _isLoading = true;
    _error = '';

    try {
      final items = await _bannerService.fetchBanners();

      if (items.isNotEmpty) {
        _banners = items.map((item) {
          return {
            'id': item['id'] ?? item['_id'],
            'name': item['name'] ?? '',
            'image':
                item['image'] ?? item['image_url'] ?? item['file_banner'] ?? '',
            'link': item['link'] ?? '',
            'orderBy': item['order_by'] ?? item['orderBy'] ?? '0',
            // Include other fields you might need
          };
        }).toList();
      } else {
        _banners = [];
      }
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

  // Optional: Reload data
  Future<void> reload() async {
    await loadBanner();
  }
}
