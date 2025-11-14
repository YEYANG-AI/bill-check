import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/service/customer_service/customer_service.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> customers = [];
  final TextEditingController _searchController = TextEditingController();
  final CustomerService _service = CustomerService();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    print('customers: $customers');
  }

  Future<void> _loadCustomers() async {
    try {
      final allCustomers = await _service.fetchCustomers();
      setState(() {
        customers = allCustomers;
      });
    } catch (e) {
      print('Error loading customers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: customers.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return Card(
                  child: ListTile(
                    title: Text('${c.name} ${c.surname}'),
                    subtitle: Text(c.tel),
                    onTap: () async {
                      await HiveDatabase.instance.saveCustomerSelected(
                        c.name,
                        c.tel,
                      );
                      // Navigator.pushNamed(
                      //   context,
                      //   RouterPath.clothesview,
                      //   arguments: c,
                      // );
                      print('Customer selected: ${c.name}');
                      print('Customer selected: ${c.id}');
                    },
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Edit customer logic
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Delete customer logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
