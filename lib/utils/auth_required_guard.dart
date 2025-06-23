import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'constants.dart';

class AuthRequiredGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (supabase.auth.currentUser == null) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }
    return null;
  }
}