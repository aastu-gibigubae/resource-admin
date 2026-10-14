class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'https://resource-app-h7e9.onrender.com';

  // Auth
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Admin - Users
  static const String users = '/admin/users';
  static const String grantPremium = '/admin/users/{id}/grant-premium';
  static const String revokeDevice = '/admin/users/{id}/revoke-device';

  // Admin - Resources
  static const String resources = '/admin/resources';

  // Taxonomy
  static const String streams = '/streams';
  static const String departments = '/departments';
  static const String courses = '/courses';

  // Dashboard
  static const String dashboardReports = '/admin/reports';
  static const String dashboardReportsResolve = '/admin/reports/{id}/resolve';
}
