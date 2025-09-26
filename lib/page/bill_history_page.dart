import 'package:flutter/material.dart';
import 'package:billcheck/components/hive_database.dart';

class BillHistoryPage extends StatelessWidget {
  const BillHistoryPage({super.key});

  Future<List<Map<String, dynamic>>> _loadBills() async {
    return HiveDatabase.instance.loadBillHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "ປະຫວັດບິນ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "ຍັງບໍ່ມີບິນ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final bills = snapshot.data!;

          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              final customer = bill['customer'] ?? {};
              final items = (bill['items'] as List)
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList();

              final date = bill['date'] ?? '';

              final total = items.fold<int>(
                0,
                (sum, item) =>
                    sum + (item['count'] as int) * (item['price'] as int),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "${customer['name']} (${customer['phone']})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("ວັນທີ: $date"),
                  children: [
                    ...items.map(
                      (item) => ListTile(
                        title: Text(item['name']),
                        trailing: Text(
                          "${item['count']} × ${item['price']} = ${(item['count'] * item['price'])}",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "ລາຄາລວມ: $total ກີບ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
