import 'package:flutter/material.dart';

class CustomerViewModel extends ChangeNotifier {
  String customerName = '';
  String customerSurname = '';
  String customerTel = '';
  String customerEmail = '';
  String customerAddress = '';

  void updateCustomer(
    String name,
    String surname,
    String phone,
    String email,
    String address,
  ) {
    customerName = name;
    customerSurname = surname;
    customerTel = phone;
    customerEmail = email;
    customerAddress = address;
    notifyListeners();
  }

  void loadCustomer() {
    customerName = '';
    customerSurname = '';
    customerTel = '';
    customerEmail = '';
    customerAddress = '';
    notifyListeners();
  }
}
