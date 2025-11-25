import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/viewmodel/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerViewModel>().getCustomers();
    });
  }

  Widget addCustomerDialog() {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Customer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Check for empty fields
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter name")),
                    );
                    return;
                  }

                  if (surnameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter surname")),
                    );
                    return;
                  }

                  if (phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter phone number"),
                      ),
                    );
                    return;
                  }

                  if (!emailController.text.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid email"),
                      ),
                    );
                    return;
                  }

                  if (addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter address")),
                    );
                    return;
                  }

                  await context.read<CustomerViewModel>().addCustomer(
                    nameController.text,
                    surnameController.text,
                    phoneController.text,
                    emailController.text,
                    addressController.text,
                  );

                  // Clear controllers after adding
                  nameController.clear();
                  surnameController.clear();
                  phoneController.clear();
                  emailController.clear();
                  addressController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteCustomerDialog(int id) {
    return AlertDialog(
      title: const Text('ຕ້ອງການລົບລາຍການທີ່ເລື່ອກທັງໝົດແທ້ບໍ່?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () async {
            await context.read<CustomerViewModel>().deleteCustomer(id);
            Navigator.pop(context);
          },
          child: const Text('ຕົກລົງ'),
        ),
      ],
    );
  }

  Widget updateCustomerDialog(Customer customer) {
    // pre-fill the controllers with current customer data
    nameController.text = customer.name;
    surnameController.text = customer.surname;
    phoneController.text = customer.tel;
    emailController.text = customer.email;
    addressController.text = customer.address;

    return AlertDialog(
      title: const Text('Update Customer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await context.read<CustomerViewModel>().updateCustomer(
              customer.id, // pass the correct id
              nameController.text,
              surnameController.text,
              phoneController.text,
              emailController.text,
              addressController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerViewModel>();
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
          'ຈັດການຂໍ້ມູນລູກຄ້າ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => addCustomerDialog(),
                  );
                },
                child: Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : vm.customers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'ບໍ່ມີລູກຄ້າ',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ກະລຸນາເພີ່ມລູກຄ້າໂດຍການກົດປຸ່ມ +',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: vm.customers.length,
              itemBuilder: (context, index) {
                final c = vm.customers[index];
                return Card(
                  child: ListTile(
                    title: Text('${c.name} ${c.surname}'),
                    subtitle: Text(c.tel),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => updateCustomerDialog(c),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    deleteCustomerDialog(c.id),
                              );
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
