
/// Konfigurasi alamat Laravel REST API.
class ApiConfig {
  static const baseUrl = 'http://127.0.0.1:8000/api';

  // Authentication
  static const register = '/register';
  static const login = '/login';
  static const logout = '/logout';
  static const profile = '/profile';

  // Restoran & Menu
  static const restaurants = '/restaurants';
  static String restaurantDetail(String id) => '/restaurants/$id';
  static String restaurantMenus(String id) => '/restaurants/$id/menus';
  static String restaurantReviews(String id) => '/restaurants/$id/reviews';
  static const menus = '/menus';

  // Reservasi
  static const reservations = '/reservations';
  static String reservationStatus(String id) => '/reservations/$id/status';

  // Dashboard Admin Restoran
  static const adminDashboard = '/admin/dashboard';

  // Dashboard Administrator
  static const administratorDashboard = '/administrator/dashboard';

  // Persetujuan restoran oleh Administrator
  static String approveRestaurant(String id) =>
      '/restaurants/$id/approve';

  static String rejectRestaurant(String id) =>
      '/restaurants/$id/reject';
}
