import 'package:billcheck/model/user_models.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:billcheck/views/history/page/history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerUser extends StatelessWidget {
  const DrawerUser({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context, listen: true);
    User? user = provider.user;

    Widget logoutDialog() {
      return AlertDialog(
        title: const Text('ຕ້ອງການອອກຈາກລະບົບແທ້ບໍ່?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouterPath.login,
                (route) => false,
              );
            },
            child: const Text('ຕົກລົງ'),
          ),
        ],
      );
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 🔹 User Info Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'ຜູ້ໃຊ້',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      user?.email ?? 'ອີເມວ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  text: 'ໜ້າຫຼັກ',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.history_rounded,
                  text: 'ປະຫວັດ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // 🔹 Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildDrawerItem(
              icon: Icons.logout_rounded,
              text: 'ອອກຈາກລະບົບ',
              color: Colors.redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => logoutDialog(),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
      hoverColor: Colors.blue.shade50,
      splashColor: Colors.blue.shade100,
    );
  }
}
