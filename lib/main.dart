import 'package:billcheck/service/hive/hive_database.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billcheck/providers/provider.dart'; // 👈 or provider_setup.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.instance.initHive();
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: LoginPage(),
      initialRoute: RouterPath.splashScreen,
      routes: RouterPath.routes,
    );
  }
}
