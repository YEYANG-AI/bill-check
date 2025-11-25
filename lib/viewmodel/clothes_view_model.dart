// clothes_view_model.dart
import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/model/laundry_model.dart';
import 'package:billcheck/service/clothes_service/clothes_service.dart';
import 'package:billcheck/service/laundry_service/laundry_service.dart';
import 'package:flutter/foundation.dart';

class ClothesViewModel with ChangeNotifier {
  final ClothesService _clothesService = ClothesService();
  final OrderService _orderService = OrderService();

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  String _error = '';
  bool _isSendingOrder = false;
  Customer? _selectedCustomer;

  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isSendingOrder => _isSendingOrder;
  Customer? get selectedCustomer => _selectedCustomer;
  bool get hasCustomer => _selectedCustomer != null;

  void setCustomer(Customer customer) {
    _selectedCustomer = customer;
    // notifyListeners();
  }

  void clearCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final apiItems = await _clothesService.fetchItems();
      _items = apiItems.map((item) {
        return {
          'name': item['name'] ?? '',
          'price': item['price'] is int
              ? item['price']
              : int.tryParse(item['price'].toString()) ?? 0,
          'count': 0,
          'id': item['id'] ?? item['_id'],
        };
      }).toList();
    } catch (e) {
      _error = e.toString();
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
      'id': DateTime.now().millisecondsSinceEpoch,
    });
    notifyListeners();
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

  Order _createOrderFromSelectedItems() {
    final orderDetails = <OrderDetail>[];
    for (var item in _items) {
      final count = item['count'] as int;
      if (count > 0) {
        orderDetails.add(
          OrderDetail(
            clothesId: item['id'] is int
                ? item['id']
                : int.tryParse(item['id'].toString()) ?? 0,
            quantity: count,
          ),
        );
      }
    }

    if (_selectedCustomer == null) {
      throw Exception('No customer selected');
    }

    return Order(customerId: _selectedCustomer!.id, details: orderDetails);
  }

  Future<int?> sendOrder() async {
    // Changed to return order ID
    if (_selectedCustomer == null) {
      _error = 'ກະລຸນາເລືອກລູກຄ້າກ່ອນ';
      notifyListeners();
      return null;
    }

    _isSendingOrder = true;
    _error = '';
    notifyListeners();

    try {
      final order = _createOrderFromSelectedItems();
      final orderId = await _orderService.createOrder(order);

      _isSendingOrder = false;
      notifyListeners();
      print('Order sent successfully with ID: $orderId');

      return orderId;
    } catch (e) {
      _isSendingOrder = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> addColthes(String name, int price) async {
    try {
      await _clothesService.addItem(name, price);
      await loadItems();
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Future<void> deleteClothes(int id) async {
    try {
      await _clothesService.deleteItem(id);
      await loadItems();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> updateClothes(int id, String name, int price) async {
    try {
      await _clothesService.updateItem(id, name, price);
      await loadItems();
    } catch (e) {
      print('Error updating item: $e');
    }
  }
}
