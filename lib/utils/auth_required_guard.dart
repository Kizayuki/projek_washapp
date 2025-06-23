import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

class AuthRequiredGuard extends GetMiddleware {
  @override
  int? get priority => 1; // Prioritas middleware

  @override
  RouteSettings? redirect(String? route) {
    // Jika tidak ada sesi pengguna Supabase, arahkan ke halaman login
    if (supabase.auth.currentUser == null) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }
    return null; // Lanjutkan ke rute yang diminta
  }
}
