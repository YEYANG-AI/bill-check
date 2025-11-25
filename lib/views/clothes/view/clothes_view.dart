import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/views/bill/view/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billcheck/viewmodel/clothes_view_model.dart';

class ClothesView extends StatefulWidget {
  const ClothesView({super.key});

  @override
  State<ClothesView> createState() => _ClothesViewState();
}

class _ClothesViewState extends State<ClothesView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the customer from arguments
    final customer = ModalRoute.of(context)?.settings.arguments as Customer?;
    if (customer != null) {
      context.read<ClothesViewModel>().setCustomer(customer);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClothesViewModel>().loadItems();
    });
  }

  // Add customer info widget
  Widget _buildCustomerInfo(ClothesViewModel viewModel) {
    if (!viewModel.hasCustomer) {
      return Container(); // Or show a message to select customer
    }

    final customer = viewModel.selectedCustomer!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.person, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(customer.tel, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  viewModel.clearCustomer();
                  Navigator.pop(context); // Go back to customer selection
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // In your _handleSaveButton method in ClothesView
  void _handleSaveButton(
    BuildContext context,
    ClothesViewModel viewModel,
  ) async {
    if (!viewModel.hasCustomer) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ກະລຸນາເລືອກລູກຄ້າກ່ອນ')));
      return;
    }

    if (viewModel.totalPrice == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ກະລຸນາເລືອກເຄື່ອງກ່ອນ')));
      return;
    }

    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ຢືນຢັນການບັນທຶກ'),
        content: Text(
          'ທ່ານຕ້ອງການບັນທຶກລາຍການໃຫ້ ${viewModel.selectedCustomer!.name} ແທ້ບໍ່?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ຕົກລົງ'),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return;

    final orderId = await viewModel.sendOrder();

    if (orderId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bill(
            orderId: orderId, // Only pass order ID
            customer: viewModel.selectedCustomer!,
          ),
        ),
      ).then((_) {
        viewModel.clearAllCounts();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ບໍ່ສາມາດສົ່ງຂໍ້ມູນ: ${viewModel.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('ກຳລັງໂຫຼດຂໍ້ມູນ...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ClothesViewModel>().loadItems();
            },
            child: const Text('ລອງໃໝ່'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(ClothesViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: List.generate(viewModel.items.length, (index) {
        final item = viewModel.items[index];
        return GestureDetector(
          onTap: () {
            viewModel.incrementItemCount(index);
          },

          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item['price']} ກີບ',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              if ((item['count'] as int) > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      viewModel.decrementItemCount(index);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if ((item['count'] as int) > 0)
                Positioned(
                  bottom: -8,
                  right: 0,
                  child: Container(
                    height: 36,
                    width: 80,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "ຈຳນວນ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "${item['count']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _addProductDialog(ClothesViewModel viewModel) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return AlertDialog(
      title: const Text('ເພີ່ມລາຍການໃໝ່'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'ຊື່ລາຍການ'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ລາຄາ'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            final String name = nameController.text.trim();
            final int? price = int.tryParse(priceController.text.trim());

            if (name.isNotEmpty && price != null && price > 0) {
              viewModel.addColthes(name, price);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ກະລຸນາໃສ່ຊື່ແລະລາຄາຖືກຕ້ອງ')),
              );
            }
          },
          child: const Text('ບັນທຶກ'),
        ),
      ],
    );
  }

  Widget _clearSelectItemDialog(ClothesViewModel viewModel) {
    return AlertDialog(
      title: const Text('ຕ້ອງການລົບລາຍການທີ່ເລື່ອກທັງໝົດແທ້ບໍ່?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            viewModel.clearAllCounts();
            Navigator.pop(context);
          },
          child: const Text('ຕົກລົງ'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClothesViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Alinda Mary Laundry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              if (viewModel.isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => _addProductDialog(viewModel),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          body: Container(
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: Column(
              children: [
                _buildCustomerInfo(viewModel),
                Expanded(
                  child: viewModel.isLoading
                      ? _buildLoadingState()
                      : viewModel.error.isNotEmpty
                      ? _buildErrorState(viewModel.error)
                      : _buildProductGrid(viewModel),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ລວມທັງໝົດ: ${viewModel.totalPrice} ກີບ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (viewModel.selectedItems.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => _clearSelectItemDialog(viewModel),
                            );
                          },
                          child: const Text(
                            'ລ້າງທັງໝົດ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () => _handleSaveButton(context, viewModel),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: viewModel.totalPrice > 0
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: viewModel.isSendingOrder
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'ບັນທຶກ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
