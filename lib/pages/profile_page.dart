import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/profile.dart';
import '../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        showSnackbar('Error', 'Pengguna tidak terautentikasi.', isError: true);
        return;
      }

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (data != null) {
        final profile = Profile.fromJson(data);
        _usernameController.text = profile.username ?? '';
        _fullNameController.text = profile.fullName ?? '';
        _phoneNumberController.text = profile.phoneNumber ?? '';
      }
    } catch (e) {
      showSnackbar('Error', 'Gagal memuat profil: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    showLoading();
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        showSnackbar('Error', 'Pengguna tidak terautentikasi.', isError: true);
        return;
      }

      await supabase.from('profiles').update({
        'username': _usernameController.text.trim(),
        'full_name': _fullNameController.text.trim(),
        'phone_number': _phoneNumberController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      // Perbarui nama di AuthController dan GetStorage
      await authController.currentUserName?.value = _fullNameController.text.trim();
      await GetStorage().write('user_name', _fullNameController.text.trim());

      showSnackbar('Berhasil', 'Profil berhasil diperbarui!');
    } catch (e) {
      showSnackbar('Error', 'Gagal memperbarui profil: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
      hideLoading();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Perbarui Profil',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}