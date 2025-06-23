import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan AuthController terinisialisasi
    if (Get.find<AuthController>() == null) {
      Get.put(AuthController());
    }

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Baru'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: usernameController,
              labelText: 'Username',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: fullNameController,
              labelText: 'Nama Lengkap',
              prefixIcon: Icons.badge,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: phoneController,
              labelText: 'Nomor Telepon',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone,
            ),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          username: usernameController.text.trim(),
                          fullName: fullNameController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Daftar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.back(); // Kembali ke halaman login
              },
              child: const Text(
                'Sudah punya akun? Login',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
