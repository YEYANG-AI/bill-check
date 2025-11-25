import 'package:billcheck/routes/router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class MenuBody extends StatelessWidget {
  const MenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {'icon': Icons.person, 'label': 'ລູກຄ້າ', 'route': RouterPath.customer},
      {'icon': Icons.receipt, 'label': 'ໃບບິນ', 'route': RouterPath.createBill},
      {
        'icon': LucideIcons.shirt,
        'label': 'ເຄື່ອງ',
        'route': RouterPath.clothesManagement,
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, items[index]['route']);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[index]['icon'], size: 40, color: Colors.blue),
                    SizedBox(height: 4),
                    Text(
                      items[index]['label'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
