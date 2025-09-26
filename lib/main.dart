import 'package:billcheck/components/hive_database.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.instance.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: LoginPage(),
      initialRoute: RouterPath.login,
      routes: RouterPath.routes,
    );
  }
}
