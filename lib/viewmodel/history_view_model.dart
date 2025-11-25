import 'package:billcheck/model/history_model.dart';
import 'package:flutter/foundation.dart';
import 'package:billcheck/service/history_service/history_service.dart';

class HistoryViewModel with ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<HistoryOrder> _orders = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 1;
  bool _hasMore = true;

  List<HistoryOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadOrderHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _orders.clear();
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _historyService.fetchOrderHistory(
        page: _currentPage,
        limit: 10,
      );

      if (refresh) {
        _orders = response.data;
      } else {
        _orders.addAll(response.data);
      }

      // Handle pagination safely
      if (response.pagination != null && response.pagination!.isNotEmpty) {
        final totalPages = response.pagination!['total_pages'] ?? 1;
        _hasMore = _currentPage < totalPages;
        _currentPage++;
      } else {
        // If no pagination info, assume it's all loaded
        _hasMore = false;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void refreshHistory() {
    loadOrderHistory(refresh: true);
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
