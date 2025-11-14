import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/service/customer_service/customer_service.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:flutter/material.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({super.key});

  @override
  State<CreateBill> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CreateBill> {
  List<Customer> customers = [];
  final TextEditingController _searchController = TextEditingController();
  final CustomerService _service = CustomerService();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
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
      appBar: AppBar(title: const Text('Customers'), centerTitle: true),
      body: customers.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  child: ListTile(
                    title: Text('${customer.name} ${customer.surname}'),
                    subtitle: Text(customer.tel),
                    onTap: () async {
                      await HiveDatabase.instance.saveCustomerSelected(
                        customer.name,
                        customer.tel,
                      );

                      // Navigate to ClothesView and pass the customer
                      Navigator.pushNamed(
                        context,
                        RouterPath.clothesview,
                        arguments: customer, // Pass the customer object
                      );

                      print('Customer selected: ${customer.name}');
                      print('Customer ID: ${customer.id}');
                    },
                  ),
                );
              },
            ),
    );
  }
}
