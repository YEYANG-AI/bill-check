import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/model/history_model.dart';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/service/laundry_service/laundry_service.dart';
import 'package:flutter/material.dart';

class Bill extends StatefulWidget {
  final int orderId; // Only need order ID
  final Customer customer;

  const Bill({super.key, required this.orderId, required this.customer});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  final OrderService _orderService = OrderService();
  HistoryOrder? _order;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadOrderFromApi();
  }

  Future<void> _loadOrderFromApi() async {
    try {
      // Fetch complete order details from API using the order ID
      final order = await _orderService.getOrderById(widget.orderId);
      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading order from API: $e');
      setState(() {
        _error = 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນອໍເດີ: $e';
        _isLoading = false;
      });
    }
  }

  // ... rest of your Bill widget code remains the same
  String _formatDate(String? dateString) {
    if (dateString == null) return 'ບໍ່ຮູ້ວັນທີ';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'ວັນທີບໍ່ຖືກຕ້ອງ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: _isLoading
                  ? _buildLoadingState()
                  : _error.isNotEmpty
                  ? _buildErrorState()
                  : _order != null
                  ? _buildOrderContent(_order!)
                  : _buildErrorState(),
            ),
          ),
        ],
      ),
    );
  }

  // ... rest of your existing Bill methods remain the same
  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('ກຳລັງໂຫຼດລາຍລະອຽດອໍເດີ...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'ເກີດຂໍ້ຜິດພາດ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrderFromApi,
              child: const Text('ລອງໃໝ່'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContent(HistoryOrder order) {
    final formattedDate = _formatDate(order.createdAt);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success icon
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.check_rounded, size: 50, color: Colors.green),
          ),
        ),
        const SizedBox(height: 24),

        // Customer information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                "ຊື່:",
                order.customer?.fullName ?? widget.customer.name,
              ),
              _buildInfoRow(
                'ເບີໂທ:',
                order.customer?.tel ?? widget.customer.tel,
              ),
              _buildInfoRow('ວັນທີ:', formattedDate),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Order items header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'ລາຍການ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'ລວມ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Order items from API - Scrollable section
        Container(
          height: 150, // Set a fixed height or use constraints
          child: ListView(
            shrinkWrap: true,
            children: order.details
                .map(
                  (detail) => ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${detail.quantity ?? 0}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    title: Text(detail.clothes.name ?? 'ບໍ່ຮູ້ຊື່ສິນຄ້າ'),
                    subtitle: detail.clothes.price != null
                        ? Text(
                            'ລາຄາ: ${detail.clothes.price!.toStringAsFixed(0)} ກີບ',
                          )
                        : const Text('ບໍ່ມີລາຄາ'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(detail.total ?? 0).toStringAsFixed(0)} ກີບ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if ((detail.vat ?? 0) > 0)
                          Text(
                            'VAT ${((detail.vat ?? 0) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Order Summary (like history page)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'ລວມຍ່ອຍ:',
                  '${(order.subTotal ?? 0).toStringAsFixed(0)} ກີບ',
                ),
                if ((order.vat ?? 0) > 0)
                  _buildSummaryRow(
                    'VAT (${((order.vat ?? 0) * 100).toStringAsFixed(0)}%):',
                    '${(order.totalVat ?? 0).toStringAsFixed(0)} ກີບ',
                  ),
                const Divider(),
                _buildSummaryRow(
                  'ລວມທັງໝົດ:',
                  '${(order.total ?? 0).toStringAsFixed(0)} ກີບ',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        _buildDivider(),

        // Complete button
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouterPath.dashboard,
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text("ສຳເລັດ", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.blue)),
        Container(
          width: 20,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
