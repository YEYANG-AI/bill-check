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
  bool _isLoading = false;

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
    bool _isLoading = false;

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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : const Icon(
                            Icons.add_circle_outline,
                            color: Colors.blue,
                            size: 30,
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _isLoading ? 'ກຳລັງເພີ່ມ...' : 'ເພີ່ມລາຍການໃໝ່',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLoading ? 'ກະລຸນາລໍຖ້າ' : 'ກະລຸນາໃສ່ຂໍ້ມູນລາຍການໃໝ່',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  IgnorePointer(
                    ignoring: _isLoading,
                    child: Opacity(
                      opacity: _isLoading ? 0.6 : 1.0,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'ຊື່ລາຍການ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.label_outline),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'ລາຄາ (ກີບ)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.attach_money_rounded,
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
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
                          onPressed: _isLoading
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
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  final String name = nameController.text
                                      .trim();
                                  final int? price = int.tryParse(
                                    priceController.text.trim(),
                                  );

                                  if (name.isNotEmpty &&
                                      price != null &&
                                      price > 0) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await viewModel.addColthes(name, price);

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (mounted) {
                                      Navigator.pop(context);
                                      _showModernSnackBar(
                                        context,
                                        'ເພີ່ມລາຍການສຳເລັດ',
                                        isError: false,
                                      );
                                    }
                                  } else {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ຊື່ແລະລາຄາໃຫ້ຖືກຕ້ອງ',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'ບັນທຶກ',
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

  Widget _deleteClothesDialog(ClothesViewModel viewModel, int id) {
    bool _isLoading = false;
    final item = viewModel.items.firstWhere((item) => item['id'] == id);

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
                  child: _isLoading
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
                  _isLoading ? 'ກຳລັງລົບ...' : 'ຢືນຢັນການລົບ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoading ? 'ກະລຸນາລໍຖ້າ' : 'ທ່ານຕ້ອງການລົບລາຍການ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'],
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
                        onPressed: _isLoading
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
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                await viewModel.deleteClothes(id);

                                setState(() {
                                  _isLoading = false;
                                });

                                if (mounted) {
                                  Navigator.pop(context);
                                  _showModernSnackBar(
                                    context,
                                    'ລົບລາຍການສຳເລັດ',
                                    isError: false,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
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

  Widget _updateClothesDialog(ClothesViewModel viewModel, int id) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    bool _isLoading = false;

    // Pre-fill data
    final item = viewModel.items.firstWhere((item) => item['id'] == id);
    nameController.text = item['name'];
    priceController.text = item['price'].toString();

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
                    child: _isLoading
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
                    _isLoading ? 'ກຳລັງແກ້ໄຂ...' : 'ແກ້ໄຂລາຍການ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLoading ? 'ກະລຸນາລໍຖ້າ' : item['name'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  IgnorePointer(
                    ignoring: _isLoading,
                    child: Opacity(
                      opacity: _isLoading ? 0.6 : 1.0,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'ຊື່ລາຍການ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.label_outline),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'ລາຄາ (ກີບ)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.attach_money_rounded,
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.05),
                            ),
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
                          onPressed: _isLoading
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
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  final String name = nameController.text
                                      .trim();
                                  final int? price = int.tryParse(
                                    priceController.text.trim(),
                                  );

                                  if (name.isNotEmpty &&
                                      price != null &&
                                      price > 0) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await viewModel.updateClothes(
                                      id,
                                      name,
                                      price,
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (mounted) {
                                      Navigator.pop(context);
                                      _showModernSnackBar(
                                        context,
                                        'ແກ້ໄຂລາຍການສຳເລັດ',
                                        isError: false,
                                      );
                                    }
                                  } else {
                                    _showModernSnackBar(
                                      context,
                                      'ກະລຸນາໃສ່ຊື່ແລະລາຄາໃຫ້ຖືກຕ້ອງ',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
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
              'ຈັດການຂໍ້ມູນເຄື່ອງ',
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
