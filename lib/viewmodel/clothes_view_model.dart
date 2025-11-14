// clothes_view_model.dart
import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/model/laundry_model.dart';
import 'package:billcheck/service/clothes_service/clothes_service.dart';
import 'package:billcheck/service/laundry_service/laundry_service.dart';
import 'package:flutter/foundation.dart';
import 'package:billcheck/service/hive/hive_database.dart';

class ClothesViewModel with ChangeNotifier {
  final HiveDatabase _hiveDatabase = HiveDatabase.instance;
  final ClothesService _clothesService = ClothesService();
  final OrderService _orderService = OrderService();

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String _error = '';

  //---- for laundry service

  bool _isSendingOrder = false;
  Customer? _selectedCustomer;

  bool get isSendingOrder => _isSendingOrder;
  Customer? get selectedCustomer => _selectedCustomer;
  bool get hasCustomer => _selectedCustomer != null;

  //-----end

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  String get error => _error;

  void setCustomer(Customer customer) {
    _selectedCustomer = customer;
    // notifyListeners();
  }

  void clearCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }

  // Load items from API first, then fall back to Hive
  Future<void> loadItems() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Try to load from API first
      final apiItems = await _clothesService.fetchItems();

      if (apiItems.isNotEmpty) {
        _items = apiItems.map((item) {
          return {
            'name': item['name'] ?? '',
            'price': item['price'] is int
                ? item['price']
                : int.tryParse(item['price'].toString()) ?? 0,
            'count': 0, // Initialize count to 0
            'id': item['id'] ?? item['_id'], // Handle both id formats
          };
        }).toList();

        // Save API data to Hive for offline use
        await _hiveDatabase.saveAllItems(_items);
      } else {
        // Fall back to Hive if API returns empty
        _items = await _hiveDatabase.loadAllItems();
      }
    } catch (e) {
      _error = e.toString();
      // Fall back to Hive on error
      _items = await _hiveDatabase.loadAllItems();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateItemCount(int index, int count) {
    if (index >= 0 && index < _items.length) {
      _items[index]['count'] = count;
      notifyListeners();
    }
  }

  void incrementItemCount(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index]['count'] = (_items[index]['count'] as int) + 1;
      notifyListeners();
    }
  }

  void decrementItemCount(int index) {
    if (index >= 0 && index < _items.length) {
      final currentCount = _items[index]['count'] as int;
      if (currentCount > 0) {
        _items[index]['count'] = currentCount - 1;
        notifyListeners();
      }
    }
  }

  void clearAllCounts() {
    for (var item in _items) {
      item['count'] = 0;
    }
    notifyListeners();
  }

  void addNewItem(String name, int price) {
    _items.add({
      'name': name,
      'price': price,
      'count': 0,
      'id': DateTime.now().millisecondsSinceEpoch, // Temporary local ID
    });
    notifyListeners();
    // Save to Hive immediately
    _hiveDatabase.saveAllItems(_items);
  }

  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += (item['price'] as int) * (item['count'] as int);
    }
    return total;
  }

  List<Map<String, dynamic>> get selectedItems {
    return _items.where((item) => (item['count'] as int) > 0).toList();
  }

  //---- for laundry service

  // Add method to create Order object from selected items
  Order _createOrderFromSelectedItems() {
    final orderDetails = <OrderDetail>[];
    for (var item in _items) {
      final count = item['count'] as int;
      if (count > 0) {
        orderDetails.add(OrderDetail(clothesId: item['id'], quantity: count));
      }
    }

    if (_selectedCustomer == null) {
      throw Exception('No customer selected');
    }

    return Order(
      customerId: _selectedCustomer!.id, // Use the actual customer ID
      details: orderDetails,
    );
  }

  // Add method to send order
  Future<bool> sendOrder() async {
    if (_selectedCustomer == null) {
      _error = 'ກະລຸນາເລືອກລູກຄ້າກ່ອນ';
      notifyListeners();
      return false;
    }

    _isSendingOrder = true;
    _error = '';
    notifyListeners();

    try {
      final order = _createOrderFromSelectedItems();
      final success = await _orderService.createOrder(order);

      _isSendingOrder = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isSendingOrder = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update display method
  Map<String, dynamic> getOrderDataForDisplay() {
    return _createOrderFromSelectedItems().toJson();
  }
}
