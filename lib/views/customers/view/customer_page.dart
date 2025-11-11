import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/service/customer_service/customer_service.dart';
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
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadCustomers(),
          ),
        ],
      ),
      body: customers.isEmpty
          ? const Center(child: Text('No customers found'))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return Card(
                  child: ListTile(
                    title: Text('${c.name} ${c.surname}'),
                    subtitle: Text(c.tel),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouterPath.clothesview,
                        arguments: c,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
