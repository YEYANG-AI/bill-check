import 'package:billcheck/service/hive/hive_database.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:flutter/material.dart';
import 'package:billcheck/model/customer_models.dart'; // Add this import

class Bill extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> orderData; // Add this parameter
  final Customer? customer; // Add customer parameter (optional)

  const Bill({
    super.key,
    required this.items,
    required this.orderData, // Add to constructor
    this.customer, // Make it optional for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    // Use the passed customer or fall back to Hive
    final user = customer != null
        ? {'name': customer!.name, 'phone': customer!.tel}
        : HiveDatabase.instance.loadCustomerSelected();

    final date = DateTime.now().toString().substring(0, 10); // Use current date
    final totalPrice = items.fold<int>(
      0,
      (sum, item) => sum + (item['count'] as int) * (item['price'] as int),
    );

    List<Map<String, dynamic>> saveItemsForBill(
      List<Map<String, dynamic>> items,
    ) {
      return items
          .where((item) => item['count'] > 0)
          .map(
            (item) => {
              'name': item['name'],
              'price': item['price'],
              'count': item['count'],
            },
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Display order data that was sent to backend
                  // if (orderData.isNotEmpty) ...[
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(12),
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey[100],
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(color: Colors.blue),
                  //       ),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text(
                  //             'ຂໍ້ມູນທີ່ສົ່ງໄປຍັງຖານຂໍ້ມູນ:',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.blue,
                  //             ),
                  //           ),
                  //           const SizedBox(height: 4),
                  //           Text('Customer ID: ${orderData['customer_id']}'),
                  //           ...orderData['details'].map<Widget>((detail) {
                  //             return Text(
                  //               '• Clothes ID: ${detail['clothes_id']}, Quantity: ${detail['quantity']}',
                  //               style: const TextStyle(fontSize: 12),
                  //             );
                  //           }).toList(),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  //   const SizedBox(height: 16),
                  // ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("ຊື່:", user['name'] ?? 'User Name'),
                        _buildInfoRow('ເບີໂທ:', user['phone'] ?? 'User Phone'),
                        _buildInfoRow('ວັນທີ:', date),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ລາຍການ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ຈຳນວນ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...items.where((item) => item['count'] > 0).map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${item['count']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ລາຄາລວມ:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalPrice ກີບ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.blue)),
                      Container(
                        width: 20,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final billItems = saveItemsForBill(items);
                      // Save bill to Hive
                      HiveDatabase.instance.saveBill(billItems);

                      // ✅ Clear all item counts
                      for (var item in items) {
                        item['count'] = 0;
                      }
                      await HiveDatabase.instance.saveAllItems(items);

                      // ✅ Clear selected customer (remove saved user)
                      await HiveDatabase.instance.clearCustomerSelected();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouterPath.dashboard,
                        (route) => false, // Remove all previous pages
                      );
                    },
                    child: const Text("ສຳເລັດ"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
