import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static final HiveDatabase instance = HiveDatabase._internal();
  HiveDatabase._internal();

  late Box userBox;
  late Box customerBox;
  late Box billBox;
  late Box itemsBox;
  Future<void> initHive() async {
    await Hive.initFlutter();
    userBox = await Hive.openBox('userBox');
    customerBox = await Hive.openBox('customerBox');
    billBox = await Hive.openBox('billItems');
    itemsBox = await Hive.openBox('itemsBox');
  }

  // -------------------- SINGLE USER --------------------
  void saveUser(String name, String phone) {
    userBox.put('user', {'name': name, 'phone': phone});
  }

  Map<String, dynamic> loadUser() {
    return Map<String, dynamic>.from(userBox.get('user', defaultValue: {}));
  }

  Map<String, dynamic> loadCustomer() {
    return Map<String, dynamic>.from(userBox.get('customer', defaultValue: {}));
  }

  // -------------------- MULTIPLE CUSTOMERS --------------------
  void addCustomer(String name, String phone) {
    customerBox.add({'name': name, 'phone': phone});
  }

  List<Map<String, dynamic>> loadAllCustomers() {
    return customerBox.values
        .where(
          (e) => e is Map && e.containsKey('name') && e.containsKey('phone'),
        )
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  void deleteCustomer(int index) {
    customerBox.deleteAt(index);
  }

  // -------------------- save customer selected --------------------

  Future<void> saveCustomerSelected(String name, String phone) async {
    final box = await Hive.openBox('customerBox');
    await box.clear(); // clear old selected customer
    await box.put('selectedCustomer', {'name': name, 'phone': phone});
  }

  Map<String, dynamic> loadCustomerSelected() {
    final box = Hive.box('customerBox');
    final customer = box.get('selectedCustomer');
    return customer != null ? Map<String, dynamic>.from(customer) : {};
  }

  Future<void> clearCustomerSelected() async {
    final box = await Hive.openBox('customerBox');
    await box.clear();
  }

  // -------------------- BILL --------------------
  void saveBill(List<Map<String, dynamic>> items) {
    billBox.add({
      'customer': loadCustomer(),
      'items': items,
      'date': DateTime.now().toIso8601String(),
    });
  }

  List<Map<String, dynamic>> loadBillHistory() {
    return billBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void clearBillHistory() {
    billBox.clear();
  }

  // -------------------- ITEMS --------------------
  Future<List<Map<String, dynamic>>> loadAllItems() async {
    if (!Hive.isBoxOpen('itemsBox')) {
      await Hive.openBox('itemsBox');
    }
    var itemsBox = Hive.box('itemsBox');
    if (itemsBox.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(
      itemsBox.values.map((e) => Map<String, dynamic>.from(e)),
    );
  }

  Future<void> saveAllItems(List<Map<String, dynamic>> items) async {
    if (!Hive.isBoxOpen('itemsBox')) {
      await Hive.openBox('itemsBox');
    }
    var itemsBox = Hive.box('itemsBox');
    await itemsBox.clear();
    for (var item in items) {
      itemsBox.add(item);
    }
  }

  Future<void> clearAll() async {
    if (!Hive.isBoxOpen('itemsBox')) {
      await Hive.openBox('itemsBox');
    }
    var itemsBox = Hive.box('itemsBox');
    await itemsBox.clear();
  }

  Future<void> clearUser() async {
    final box = await Hive.openBox('userBox');
    await box.clear();
  }

  Future<void> saveToken(String token) async {
    await userBox.put('token', token);
  }

  String? loadToken() {
    return userBox.get('token');
  }

  Future<void> clearToken() async {
    await userBox.delete('token');
  }
}
