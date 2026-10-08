/// Disiapkan untuk tahap integrasi dengan Laravel REST API.
/// Saat ini aplikasi memakai data dummy (lib/data/dummy_data.dart).
class ApiConfig {
  static const baseUrl = 'https://api.makankuy.example/api'; // GANTI nanti

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

  // Dashboard
  static const adminDashboard = '/admin/dashboard';
}