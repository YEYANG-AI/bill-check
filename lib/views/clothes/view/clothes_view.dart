import 'package:billcheck/views/bill/view/bill.dart';
import 'package:flutter/material.dart';
import '../../../service/hive/hive_database.dart'; // your hive class

class ClothesView extends StatefulWidget {
  const ClothesView({super.key});

  @override
  State<ClothesView> createState() => _HomePageState();
}

class _HomePageState extends State<ClothesView> {
  List<Map<String, dynamic>> items = [];

  int totalPrice = 0;
  final HiveDatabase hiveDatabase = HiveDatabase.instance; // ✅ Hive instance

  @override
  void initState() {
    super.initState();
    loadItemsFromHive();
  }

  void loadItemsFromHive() async {
    await hiveDatabase.initHive();
    items = await hiveDatabase.loadAllItems();
    calculateTotal();
    setState(() {});
  }

  void saveAllItemsToHive() async {
    await hiveDatabase.saveAllItems(items);
  }

  void clearAllItems() async {
    await hiveDatabase.clearAll();
  }

  void calculateTotal() {
    totalPrice = 0;
    for (var item in items) {
      totalPrice += (item['price'] as int) * (item['count'] as int);
    }
  }

  void updateTotal() {
    totalPrice = 0;
    for (var item in items) {
      totalPrice += (item['price'] as int) * (item['count'] as int);
    }
  }

  Widget clearSelectItem() {
    return AlertDialog(
      title: const Text('ຕ້ອງການລົບລາຍການທີ່ເລື່ອກທັງໝົດແທ້ບໍ່?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              for (var item in items) {
                item['count'] = 0;
              }
              updateTotal();
              hiveDatabase.saveAllItems(items);
            });
            Navigator.pop(context);
          },
          child: const Text('ຕົກລົງ'),
        ),
      ],
    );
  }

  Widget addProductDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    return AlertDialog(
      title: const Text('ເພີ່ມລາຍການໃໝ່'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'ຊື່ລາຍການ'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ລາຄາ'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
          },
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            final String name = nameController.text.trim();
            final int? price = int.tryParse(priceController.text.trim());

            if (name.isNotEmpty && price != null) {
              setState(() {
                final newItem = {'name': name, 'price': price, 'count': 0};
                items.add(newItem);
                updateTotal();

                // Save the new item to Hive
                hiveDatabase.saveAllItems(items);
              });
              Navigator.pop(context); // close dialog
            } else {
              // show error if invalid
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ກະລຸນາໃສ່ຊື່ແລະລາຄາຖືກຕ້ອງ')),
              );
            }
          },
          child: const Text('ບັນທຶກ'),
        ),
      ],
    );
  }

  // Your old build method remains completely unchanged
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Alinda Mary Laundry',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => addProductDialog(),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      body: Container(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                padding: const EdgeInsets.all(8),
                childAspectRatio: 1,
                children: List.generate(items.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        items[index]['count'] =
                            (items[index]['count'] as int) + 1;
                        updateTotal();
                        hiveDatabase.saveAllItems(items);
                      });
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  items[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                                Text(
                                  items[index]['price'].toString(),
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if ((items[index]['count'] as int) > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if ((items[index]['count'] as int) > 0) {
                                    items[index]['count'] =
                                        (items[index]['count'] as int) - 1;
                                    updateTotal();
                                  }
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.remove,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if ((items[index]['count'] as int) > 0)
                          Positioned(
                            bottom: -8,
                            right: 0,
                            child: Container(
                              height: 36,
                              width: 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(14),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      "ຈຳນວນ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${items[index]['count']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: SizedBox(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         GestureDetector(
            //           onTap: () {
            //             showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return AlertDialog(
            //                   title: const Text(
            //                     'ຕ້ອງການລົບລາຍການທັງໝົດແທ້ບໍ່?',
            //                     style: TextStyle(fontSize: 18),
            //                   ),
            //                   actions: [
            //                     TextButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: const Text('ຍົກເລີກ'),
            //                     ),
            //                     ElevatedButton(
            //                       onPressed: () {
            //                         hiveDatabase.clearAll();
            //                         setState(() {
            //                           loadItemsFromHive();
            //                         });
            //                         Navigator.pop(context);
            //                       },
            //                       child: const Text('ຕົກລົງ'),
            //                     ),
            //                   ],
            //                 );
            //               },
            //             );
            //           },
            //           child: Container(
            //             height: 40,
            //             decoration: BoxDecoration(
            //               color: Colors.red,
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             child: const Center(
            //               child: Text(
            //                 'ລົບລາຍການທັງໝົດ',
            //                 style: TextStyle(fontSize: 16, color: Colors.white),
            //               ),
            //             ),
            //           ),
            //         ),

            //         GestureDetector(
            //           onTap: () {
            //             showDialog(
            //               context: context,
            //               builder: (_) => clearSelectItem(),
            //             );
            //           },
            //           child: Container(
            //             height: 40,
            //             decoration: BoxDecoration(
            //               color: Colors.red,
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             child: const Center(
            //               child: Text(
            //                 'ລົບລາຄາທີ່ເລື່ອກທັງໝົດ',
            //                 style: TextStyle(fontSize: 16, color: Colors.white),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    'ລວມທັງໝົດ: $totalPrice ກີບ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  if (totalPrice != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bill(items: items),
                      ),
                    ).then((_) {
                      // Reset counts after returning from bill page
                      setState(() {
                        for (var item in items) {
                          item['count'] = 0;
                        }
                        updateTotal();
                        hiveDatabase.saveAllItems(
                          items,
                        ); // optional if you want to save cleared state
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ເຄື່ອງຫ້າມວ່າງ')),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'ບັນທຶກ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
