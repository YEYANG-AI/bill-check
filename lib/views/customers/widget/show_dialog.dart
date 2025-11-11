import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/service/hive/hive_database.dart';
import 'package:flutter/material.dart';

class ShowDialogPage extends StatelessWidget {
  const ShowDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget showAddCustomerDialog() {
      final nameController = TextEditingController();
      final phoneController = TextEditingController();

      return AlertDialog(
        title: const Text('Add New Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();

              if (name.isNotEmpty && phone.isNotEmpty) {
                HiveDatabase.instance.addCustomer(name, phone);
                // _loadCustomers();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    }

    return showAddCustomerDialog();
  }
}
