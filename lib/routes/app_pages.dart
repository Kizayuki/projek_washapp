import 'package:get/get.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/new_reservation_page.dart';
import '../pages/profile_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_screen.dart';
import 'app_routes.dart';
import '../utils/auth_required_guard.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      middlewares: [AuthRequiredGuard()],
    ),
    GetPage(
      name: AppRoutes.NEW_RESERVATION,
      page: () => const NewReservationPage(),
      middlewares: [AuthRequiredGuard()],
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfilePage(),
      middlewares: [AuthRequiredGuard()],
    ),
  ];
}
