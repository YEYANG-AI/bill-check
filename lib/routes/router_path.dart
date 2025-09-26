import 'package:billcheck/Auth/login_page.dart';
import 'package:billcheck/page/bill.dart';
import 'package:billcheck/page/bill_history_page.dart';
import 'package:billcheck/page/home_page.dart';
import 'package:flutter/material.dart';

class RouterPath {
  static const String login = '/login';
  static const String home = '/home';
  static const String bill = '/bill';
  static const String billHistory = '/billHistory';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    home: (context) => HomePage(),
    bill: (context) => Bill(
      items:
          ModalRoute.of(context)!.settings.arguments
              as List<Map<String, dynamic>>,
    ),
    billHistory: (context) => const BillHistoryPage(),
  };
}
