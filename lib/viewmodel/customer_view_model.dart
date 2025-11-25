import 'package:billcheck/service/customer_service/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:billcheck/model/customer_models.dart';

class CustomerViewModel extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _customerService.fetchCustomers();
    } catch (e) {
      print("Error fetching customers: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCustomer(
    String name,
    String surname,
    String phone,
    String email,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _customerService.addCustomer(name, surname, phone, email, address);
      await getCustomers();
    } catch (e) {
      print("Error adding customer: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCustomer(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _customerService.deleteCustomer(id);

      await getCustomers();
    } catch (e) {
      print("Error deleting customer: $e");
    }
    _customers.removeWhere((c) => c.id == id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCustomer(
    int id,
    String name,
    String surname,
    String phone,
    String email,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _customerService.updateCustomer(id, name, surname, phone, email, address);
      await getCustomers();
    } catch (e) {
      print("Error updating customer: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
