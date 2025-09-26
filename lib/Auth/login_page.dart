import 'package:billcheck/components/hive_database.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Processing Data...')));

      HiveDatabase.instance.saveUser(
        usernameController.text,
        phoneController.text,
      );

      Navigator.pushNamed(context, RouterPath.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(160),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: 160,
                    height: 160,
                  ),
                ),

                Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Text(
                        "BRIGHT",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 56,
                      left: 16,
                      child: Text(
                        "LAUNDRY",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Username label
                _buildLabel("ຊື່ລູກຄ້າ"),
                _buildTextField(
                  controller: usernameController,
                  hint: "Username",
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'ກະລຸນາໃສ່ຊື່ລູກຄ້າ'
                      : null,
                ),

                const SizedBox(height: 20),

                // Phone label
                _buildLabel("ເບີໂທ"),
                _buildTextField(
                  controller: phoneController,
                  hint: "Phone number",
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'ກະລຸນາໃສ່ເບີໂທ'
                      : null,
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 8,
                    ),
                    child: const Text(
                      "ບັນທຶກ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helpers to reduce duplicate code
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
