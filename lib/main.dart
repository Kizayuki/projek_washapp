import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_bindings.dart';
import 'utils/app_constants.dart';
import 'utils/app_routes.dart';
import 'pages/splash/splash_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/services/service_list_page.dart';
import 'pages/reservations/reservation_page.dart';
import 'pages/reservations/my_reservations_page.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/admin/admin_manage_services_page.dart';
import 'pages/admin/admin_view_reservasi_page.dart';
import 'pages/admin/admin_manage_users_page.dart';
import 'pages/admin/admin_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
        GetPage(name: AppRoutes.home, page: () => const HomePage()),
        GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
        GetPage(
          name: AppRoutes.serviceList,
          page: () => const ServiceListPage(),
        ),
        GetPage(
          name: AppRoutes.reservation,
          page: () => const ReservationPage(),
        ),
        GetPage(
          name: AppRoutes.myReservations,
          page: () => const MyReservationsPage(),
        ),
        GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const AdminDashboardPage(),
        ),
        GetPage(
          name: AppRoutes.adminManageServices,
          page: () => const AdminManageServicesPage(),
        ),
        GetPage(
          name: AppRoutes.adminViewReservations,
          page: () => const AdminViewReservationsPage(),
        ),
        GetPage(
          name: AppRoutes.adminManageUsers,
          page: () => const AdminManageUsersPage(),
        ),
        GetPage(
          name: AppRoutes.adminProfile,
          page: () => const AdminProfilePage(),
        ),
      ],
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
