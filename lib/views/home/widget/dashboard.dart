import 'package:billcheck/views/home/view/home_view.dart';
import 'package:billcheck/views/history/page/history_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomeView(), HistoryPage()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 100,
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  _onItemTapped(0);
                },
                child: Column(children: [Icon(Icons.home), Text("ໜ້າຫຼັກ")]),
              ),
              GestureDetector(
                onTap: () {
                  _onItemTapped(1);
                },
                child: Column(children: [Icon(Icons.history), Text("ປະຫວັດ")]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
