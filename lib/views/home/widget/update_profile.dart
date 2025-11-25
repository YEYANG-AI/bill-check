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
  bool isUploading = false;

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
          isUploading = true;
        });

        final userProvider = Provider.of<UserViewModel>(context, listen: false);

        final imageId = await userProvider.uploadImageOnly(pickedImage!);

        setState(() {
          isUploading = false;
          this.imageId = imageId;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ອັບໂຫຼດຮູບສຳເລັດ')));
      } catch (e) {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ບໍ່ສາມາດອັບໂຫຼດຮູບ: $e')));
      }
    }
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ອັບເດດໂປຣໄຟລ໌'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  child: pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.file(
                            pickedImage!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : (user?.profile?.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  user!.profile.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.person, size: 40)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade50,
                    ),
                    child: Text('ປ່ຽນຮູບພາບ'),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (val) => name = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ຕ້ອງປ້ອນຊື່' : null,
                ),
                const SizedBox(height: 8),
                // Surname
                TextFormField(
                  initialValue: surname,
                  decoration: const InputDecoration(labelText: 'Surname'),
                  onChanged: (val) => surname = val,
                ),
                const SizedBox(height: 8),
                // Email
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (val) => email = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'ຕ້ອງປ້ອນອີເມວ' : null,
                ),
                const SizedBox(height: 8),
                // Tel
                TextFormField(
                  initialValue: tel,
                  decoration: const InputDecoration(labelText: 'Tel'),
                  onChanged: (val) => tel = val,
                ),
                if (isUploading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await userProvider.updateProfile(
                          name: name,
                          surname: surname,
                          email: email,
                          tel: tel,
                          image:
                              imageId ?? user?.profile?.image, // send image ID
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('ອັບເດດສຳເລັດ')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ອັບເດດບໍ່ສຳເລັດ: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('ອັບເດດ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
