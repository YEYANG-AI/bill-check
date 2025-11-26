import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/viewmodel/customer_view_model.dart';
import 'package:billcheck/views/customers/view/add_customer_view.dart';
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

  bool _isUpdateLoading = false;
  bool _isDeleteLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerViewModel>().getCustomers();
    });
  }

  // Add this method if you don't have it
  void _showModernSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget deleteCustomerDialog(Customer customer) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: _isDeleteLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  _isDeleteLoading ? 'ກຳລັງລົບ...' : 'ຢືນຢັນການລົບ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isDeleteLoading
                      ? 'ກະລຸນາລໍຖ້າ'
                      : 'ທ່ານຕ້ອງການລົບຂໍ້ມູນຂອງລູກຄ້າ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${customer.name} ${customer.surname}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ແທ້ບໍ່?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isDeleteLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('ຍົກເລີກ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isDeleteLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isDeleteLoading = true;
                                });

                                await context
                                    .read<CustomerViewModel>()
                                    .deleteCustomer(customer.id);

                                setState(() {
                                  _isDeleteLoading = false;
                                });

                                Navigator.pop(context);
                                _showModernSnackBar(
                                  context,
                                  'ລົບຂໍ້ມູນລູກຄ້າສຳເລັດ',
                                  isError: false,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isDeleteLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ລົບ',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget updateCustomerDialog(Customer customer) {
    // Pre-fill the controllers with current customer data
    nameController.text = customer.name;
    surnameController.text = customer.surname;
    phoneController.text = customer.tel;
    emailController.text = customer.email;
    addressController.text = customer.address;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: _isUpdateLoading
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : const Icon(
                            Icons.edit_rounded,
                            color: Colors.blue,
                            size: 30,
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _isUpdateLoading ? 'ກຳລັງແກ້ໄຂ...' : 'ແກ້ໄຂຂໍ້ມູນລູກຄ້າ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isUpdateLoading
                        ? 'ກະລຸນາລໍຖ້າ'
                        : customer.name + ' ' + customer.surname,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Form fields - disabled when loading
                  IgnorePointer(
                    ignoring: _isUpdateLoading,
                    child: Opacity(
                      opacity: _isUpdateLoading ? 0.6 : 1.0,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'ຊື່',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person_outline),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: surnameController,
                            decoration: InputDecoration(
                              labelText: 'ນາມສະກຸນ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person_outlined),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'ເບີໂທລະສັບ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.phone_rounded),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'ອີເມວ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.email_rounded),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: 'ທີ່ຢູ່',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isUpdateLoading
                              ? null
                              : () {
                                  nameController.clear();
                                  surnameController.clear();
                                  phoneController.clear();
                                  emailController.clear();
                                  addressController.clear();
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('ຍົກເລີກ'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isUpdateLoading
                              ? null
                              : () async {
                                  // Validation
                                  if (nameController.text.isEmpty) {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ຊື່',
                                    );
                                    return;
                                  }

                                  if (surnameController.text.isEmpty) {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ນາມສະກຸນ',
                                    );
                                    return;
                                  }

                                  if (phoneController.text.isEmpty) {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ເບີໂທລະສັບ',
                                    );
                                    return;
                                  }

                                  if (!emailController.text.contains('@')) {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ອີເມວໃຫ້ຖືກຕ້ອງ',
                                    );
                                    return;
                                  }

                                  if (addressController.text.isEmpty) {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ທີ່ຢູ່',
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isUpdateLoading = true;
                                  });

                                  await context
                                      .read<CustomerViewModel>()
                                      .updateCustomer(
                                        customer.id,
                                        nameController.text,
                                        surnameController.text,
                                        phoneController.text,
                                        emailController.text,
                                        addressController.text,
                                      );

                                  setState(() {
                                    _isUpdateLoading = false;
                                  });

                                  // Clear controllers after updating
                                  nameController.clear();
                                  surnameController.clear();
                                  phoneController.clear();
                                  emailController.clear();
                                  addressController.clear();

                                  Navigator.pop(context);
                                  _showModernSnackBar(
                                    context,
                                    'ແກ້ໄຂຂໍ້ມູນສຳເລັດ',
                                    isError: false,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isUpdateLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'ບັນທຶກການແກ້ໄຂ',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCustomerView()),
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
                                builder: (context) => deleteCustomerDialog(c),
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
