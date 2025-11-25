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
  bool isLoading = true; // Added missing isLoading variable
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
        isLoading = false; // Set loading to false when data is loaded
      });
    } catch (e) {
      print('Error loading customers: $e');
      setState(() {
        isLoading = false; // Set loading to false even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'ສ້າງໃບບິນ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : customers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'ບໍ່ມີລູກຄ້າ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ກະລຸນາເພີ່ມລູກຄ້າກ່ອນເພື່ອເລີ່ມສ້າງໃບບິນ',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
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
