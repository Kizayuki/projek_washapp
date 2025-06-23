import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ganti dengan URL dan Anon Key Supabase Anda
const SUPABASE_URL =
    'YOUR_SUPABASE_PROJECT_URL'; // Contoh: https://abcdefghijklm.supabase.co
const SUPABASE_ANON_KEY =
    'YOUR_SUPABASE_ANON_KEY'; // Contoh: eyJhbGciOiJIUzI1Ni...

// Supabase Client instance
final supabase = Supabase.instance.client;

// Snackbar kustom untuk pesan
void showSnackbar(String title, String message, {bool isError = false}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.redAccent : Colors.green,
    colorText: Colors.white,
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}

// Loading indicator
void showLoading() {
  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );
}

void hideLoading() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}
