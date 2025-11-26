import 'package:billcheck/viewmodel/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  State<AddCustomerView> createState() => _AddState();
}

class _AddState extends State<AddCustomerView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _isLoading = false;

  void _showModernSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _addCustomer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<CustomerViewModel>().addCustomer(
        nameController.text,
        surnameController.text,
        phoneController.text,
        emailController.text,
        addressController.text,
      );

      // Clear controllers after successful addition
      nameController.clear();
      surnameController.clear();
      phoneController.clear();
      emailController.clear();
      addressController.clear();

      if (mounted) {
        Navigator.pop(context);
        _showModernSnackBar(context, 'ເພີ່ມລູກຄ້າສຳເລັດ', isError: false);
      }
    } catch (e) {
      if (mounted) {
        _showModernSnackBar(context, 'ເກີດຂໍ້ຜິດພາດ: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      _showModernSnackBar(context, 'ກະລຸນາໃສ່ຊື່');
      return false;
    }

    if (surnameController.text.isEmpty) {
      _showModernSnackBar(context, 'ກະລຸນາໃສ່ນາມສະກຸນ');
      return false;
    }

    if (phoneController.text.isEmpty) {
      _showModernSnackBar(context, 'ກະລຸນາໃສ່ເບີໂທລະສັບ');
      return false;
    }

    if (!emailController.text.contains('@')) {
      _showModernSnackBar(context, 'ກະລຸນາໃສ່ອີເມວໃຫ້ຖືກຕ້ອງ');
      return false;
    }

    if (addressController.text.isEmpty) {
      _showModernSnackBar(context, 'ກະລຸນາໃສ່ທີ່ຢູ່');
      return false;
    }

    return true;
  }

  void _clearForm() {
    nameController.clear();
    surnameController.clear();
    phoneController.clear();
    emailController.clear();
    addressController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        ignoring: _isLoading,
        child: Opacity(
          opacity: _isLoading ? 0.6 : 1.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  // Header with loading state
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 3,
                          )
                        : const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.blue,
                            size: 40,
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Title with loading state
                  Text(
                    _isLoading ? 'ກຳລັງເພີ່ມລູກຄ້າ...' : 'ເພີ່ມລູກຄ້າໃໝ່',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLoading
                        ? 'ກະລຸນາລໍຖ້າການບັນທຶກ'
                        : 'ກະລຸນາໃສ່ຂໍ້ມູນລູກຄ້າໃໝ່',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Form fields
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
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _clearForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: _isLoading ? Colors.grey : Colors.blue,
                            ),
                          ),
                          child: Text(
                            'ຍົກເລີກ',
                            style: TextStyle(
                              color: _isLoading ? Colors.grey : Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_validateForm()) {
                                    _addCustomer();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading
                                ? Colors.grey
                                : Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'ເພີ່ມລູກຄ້າ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  // Loading overlay message
                  if (_isLoading) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'ກະລຸນາຢ່າປິດໜ້າຈໍຂະນະທີ່ກຳລັງບັນທຶກ...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
