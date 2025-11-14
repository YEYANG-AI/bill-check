import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/views/Auth/view/login_view.dart';
import 'package:billcheck/views/bill/view/bill.dart';
import 'package:billcheck/views/customers/view/create_bill.dart';
import 'package:billcheck/views/customers/view/customer_page.dart';
import 'package:billcheck/views/home/view/home_view.dart';
import 'package:billcheck/views/home/widget/dashboard.dart';
import 'package:billcheck/views/clothes/view/clothes_view.dart';
import 'package:billcheck/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RouterPath {
  static const String login = '/login';
  static const String home = '/home';
  static const String bill = '/bill';
  static const String clothesview = '/clothesview';
  static const String dashboard = '/dashboard';
  static const String customer = '/customer';
  static const String splashScreen = '/splashScreen';
  static const String createBill = '/createBill';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginView(),
    clothesview: (context) => ClothesView(),
    bill: (context) => Bill(
      orderData:
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
      items:
          ModalRoute.of(context)!.settings.arguments
              as List<Map<String, dynamic>>,
      customer: ModalRoute.of(context)!.settings.arguments as Customer,
    ),
    createBill: (context) => const CreateBill(),
    home: (context) => const HomeView(),
    customer: (context) => const CustomerPage(),
    dashboard: (context) => const Dashboard(),
    splashScreen: (context) => const SplashScreen(),
  };
}
