import 'dart:io';
import 'package:billcheck/viewmodel/user_view_model.dart';
import 'package:billcheck/views/home/widget/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? surname;
  String? email;
  String? tel;
  String? imageId;

  File? pickedImage;
  bool _isUploading = false;
  bool _isUpdating = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() {
        pickedImage = File(file.path);
      });

      // Upload image immediately and get image ID
      try {
        setState(() {
          _isUploading = true;
        });

        final userProvider = Provider.of<UserViewModel>(context, listen: false);
        final imageId = await userProvider.uploadImageOnly(pickedImage!);

        setState(() {
          _isUploading = false;
          this.imageId = imageId;
        });

        _showModernSnackBar(context, 'ອັບໂຫຼດຮູບສຳເລັດ', isError: false);
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        _showModernSnackBar(context, 'ບໍ່ສາມາດອັບໂຫຼດຮູບ: $e');
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isUpdating = true;
        });

        final userProvider = Provider.of<UserViewModel>(context, listen: false);
        final user = userProvider.user;

        await userProvider.updateProfile(
          name: name,
          surname: surname,
          email: email,
          tel: tel,
          image: imageId ?? user?.profile?.image,
        );

        setState(() {
          _isUpdating = false;
        });

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
          _showModernSnackBar(context, 'ອັບເດດໂປຣໄຟລ໌ສຳເລັດ', isError: false);
        }
      } catch (e) {
        setState(() {
          _isUpdating = false;
        });
        _showModernSnackBar(context, 'ອັບເດດບໍ່ສຳເລັດ: $e');
      }
    }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    final user = userProvider.user;

    // Prefill form fields
    name ??= user?.name;
    surname ??= user?.surname;
    email ??= user?.email;
    tel ??= user?.tel;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _isUpdating ? null : () => Navigator.pop(context),
        ),
        title: Text(
          _isUpdating ? 'ກຳລັງອັບເດດ...' : 'ອັບເດດໂປຣໄຟລ໌',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: IgnorePointer(
        ignoring: _isUpdating,
        child: Opacity(
          opacity: _isUpdating ? 0.6 : 1.0,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    // Profile image section
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.grey.shade200,
                                child: _isUploading
                                    ? const CircularProgressIndicator(
                                        color: Colors.blue,
                                        strokeWidth: 3,
                                      )
                                    : pickedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(56),
                                        child: Image.file(
                                          pickedImage!,
                                          width: 112,
                                          height: 112,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : (user?.profile?.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(56),
                                              child: Image.network(
                                                user!.profile.imageUrl,
                                                width: 112,
                                                height: 112,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons.person,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                              ),
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.grey,
                                            )),
                              ),
                              if (_isUploading)
                                Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploading ? null : pickImage,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _isUploading ? Colors.grey : Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isUploading ? 'ກຳລັງອັບໂຫຼດຮູບ...' : 'ປ່ຽນຮູບພາບ',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isUploading ? Colors.grey : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: 'ຊື່',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                      ),
                      onChanged: (val) => name = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'ກະລຸນາໃສ່ຊື່' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: surname,
                      decoration: InputDecoration(
                        labelText: 'ນາມສະກຸນ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outlined),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                      ),
                      onChanged: (val) => surname = val,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: email,
                      decoration: InputDecoration(
                        labelText: 'ອີເມວ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email_rounded),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                      ),
                      onChanged: (val) => email = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'ກະລຸນາໃສ່ອີເມວ' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: tel,
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
                      onChanged: (val) => tel = val,
                    ),
                    const SizedBox(height: 40),

                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isUpdating ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isUpdating
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'ອັບເດດໂປຣໄຟລ໌',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Loading message
                    if (_isUpdating) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'ກະລຸນາລໍຖ້າການອັບເດດ...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
