import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:billcheck/views/home/widget/banner_body.dart';
import 'package:billcheck/views/home/widget/drawer_user.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/views/home/widget/menu_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  Widget logoutDialog() {
    return AlertDialog(
      title: const Text('ຕ້ອງການອອກຈາກລະບົບແທ້ບໍ່?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouterPath.login,
              (route) => false,
            );
          },
          child: const Text('ຕົກລົງ'),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Laundry',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: BannerBody(),
            ),
            MenuBody(),
          ],
        ),
      ),
    );
  }
}
