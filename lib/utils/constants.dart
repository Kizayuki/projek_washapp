import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const SUPABASE_URL = 'https://pdylbgcpupuxsdpmdssn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkeWxiZ2NwdXB1eHNkcG1kc3NuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk5MDk2NzIsImV4cCI6MjA2NTQ4NTY3Mn0.WlgHMBTvb1s1d5S_a5VJWMQvHz3b6LzFmntatpyiLpg';

final supabase = Supabase.instance.client;

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
    const Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false,
  );
}

void hideLoading() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}