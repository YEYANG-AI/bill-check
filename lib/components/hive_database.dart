import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static final HiveDatabase instance = HiveDatabase._internal();
  HiveDatabase._internal();

  late Box userBox;
  late Box billBox;
  late Box itemsBox;

  Future<void> initHive() async {
    await Hive.initFlutter();
    userBox = await Hive.openBox('userInfo');
    billBox = await Hive.openBox('billItems');
    itemsBox = await Hive.openBox('itemsBox');
  }

  // -------------------- USER --------------------
  void saveUser(String name, String phone) {
    userBox.put('user', {'name': name, 'phone': phone});
  }

  Map<String, dynamic> loadUser() {
    return Map<String, dynamic>.from(userBox.get('user'));
  }

  // -------------------- BILL --------------------
  void saveBill(List<Map<String, dynamic>> items) {
    billBox.add({
      'customer': loadUser(),
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

  void saveBillItems(List<Map<String, dynamic>> selectedItems) {
    billBox.add({
      'customer': loadUser(),
      'items': selectedItems,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Add to HiveDatabase
  Future<List<Map<String, dynamic>>> loadAllItems() async {
    if (!Hive.isBoxOpen('itemsBox')) {
      await Hive.openBox('itemsBox');
    }
    var itemsBox = Hive.box('itemsBox');
    if (itemsBox.isEmpty) {
      return []; // Empty list if no data
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
}
