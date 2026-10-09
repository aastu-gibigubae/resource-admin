// Route guard stub — checks auth state and redirects accordingly.
// Will be implemented when auth feature is completed.

import 'route_names.dart';

String? authRedirectGuard({
  required bool isAuthenticated,
  required String location,
}) {
  final publicRoutes = [
    RouteNames.splash,
    RouteNames.login,
    RouteNames.forgotPasswordEmail,
    RouteNames.forgotPasswordVerify,
    RouteNames.resetPassword,
  ];

  if (!isAuthenticated && !publicRoutes.contains(location)) {
    return RouteNames.login;
  }
  return null;
}
