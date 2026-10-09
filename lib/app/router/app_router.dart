import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/admin_auth/presentation/pages/admin_login_page.dart';
import '../../features/admin_dashboard/presentation/pages/admin_dashboard_page.dart';
import '../../features/user_management/presentation/pages/user_management_page.dart';
import '../../features/user_management/presentation/pages/user_detail_page.dart';
import '../../features/pending_requests/presentation/pages/pending_requests_page.dart';
import '../../features/resource_upload/presentation/pages/upload_resources_page.dart';
import '../../features/resource_upload/presentation/pages/upload_result_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_email_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_verify_page.dart';
import '../../features/forgot_password/presentation/pages/reset_password_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordEmail,
        builder: (context, state) => const ForgotPasswordEmailPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPasswordVerify,
        builder: (context, state) => const ForgotPasswordVerifyPage(),
      ),
      GoRoute(
        path: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: RouteNames.userManagement,
        builder: (context, state) => const UserManagementPage(),
      ),
      GoRoute(
        path: RouteNames.userDetail,
        builder: (context, state) =>
            UserDetailPage(userId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: RouteNames.pendingRequests,
        builder: (context, state) => const PendingRequestsPage(),
      ),
      GoRoute(
        path: RouteNames.uploadResources,
        builder: (context, state) => const UploadResourcesPage(),
      ),
      GoRoute(
        path: RouteNames.uploadResult,
        builder: (context, state) => const UploadResultPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});
