import 'package:billcheck/model/customer_models.dart';
import 'package:billcheck/views/bill/view/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billcheck/viewmodel/clothes_view_model.dart';

class ClothesManagement extends StatefulWidget {
  const ClothesManagement({super.key});

  @override
  State<ClothesManagement> createState() => _ClothesManagementState();
}

class _ClothesManagementState extends State<ClothesManagement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClothesViewModel>().loadItems();
    });
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

  Widget _buildEmptyState() {
    return const Center(
      child: Text('ບໍ່ມີຂໍ້ມູນ', style: TextStyle(fontSize: 18)),
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
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: List.generate(viewModel.items.length, (index) {
        final item = viewModel.items[index];
        return Stack(
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
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        _updateClothesDialog(viewModel, item['id'] as int),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.blue),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        _deleteClothesDialog(viewModel, item['id'] as int),
                  );
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
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

  Widget _deleteClothesDialog(ClothesViewModel viewModel, int id) {
    return AlertDialog(
      title: const Text('ຕ້ອງການລົບລາຍການທີ່ເລື່ອກແທ້ບໍ່?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ຍົກເລີກ'),
        ),
        ElevatedButton(
          onPressed: () {
            viewModel.deleteClothes(id);
            Navigator.pop(context);
          },
          child: const Text('ຕົກລົງ'),
        ),
      ],
    );
  }

  Widget _updateClothesDialog(ClothesViewModel viewModel, int id) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    nameController.text = viewModel.items.firstWhere(
      (item) => item['id'] == id,
    )['name'];
    priceController.text = viewModel.items
        .firstWhere((item) => item['id'] == id)['price']
        .toString();

    return AlertDialog(
      title: const Text('ແກ້ໄຂລາຍການໃໝ່'),
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
              viewModel.updateClothes(id, name, price);
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
                Expanded(
                  child: viewModel.isLoading
                      ? _buildLoadingState()
                      : viewModel.items.isEmpty
                      ? _buildEmptyState()
                      : viewModel.error.isNotEmpty
                      ? _buildErrorState(viewModel.error)
                      : _buildProductGrid(viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
