import 'package:flutter/material.dart';

import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_menu_screen.dart';
import '../screens/admin/admin_reservation_screen.dart';
import '../screens/admin/admin_restaurant_screen.dart';
import '../screens/administrator/administrator_dashboard_screen.dart';
import '../screens/administrator/category_management_screen.dart';
import '../screens/administrator/reservation_monitoring_screen.dart';
import '../screens/administrator/restaurant_approval_screen.dart';
import '../screens/administrator/user_management_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/menu/menu_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reservation/reservation_form_screen.dart';
import '../screens/reservation/reservation_history_screen.dart';
import '../screens/restaurant/restaurant_detail_screen.dart';
import '../screens/restaurant/restaurant_search_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String restaurantDetail =
      '/restaurant-detail';
  static const String restaurantSearch =
      '/restaurant-search';
  static const String menuDetail = '/menu-detail';
  static const String reservationForm =
      '/reservation-form';
  static const String reservationHistory =
      '/reservation-history';
  static const String profile = '/profile';

  static const String adminDashboard =
      '/admin-dashboard';
  static const String adminRestaurant =
      '/admin-restaurant';
  static const String adminMenu = '/admin-menu';
  static const String adminReservation =
      '/admin-reservation';

  static const String administratorDashboard =
      '/administrator-dashboard';
  static const String userManagement =
      '/user-management';
  static const String categoryManagement =
      '/category-management';
  static const String restaurantApproval =
      '/restaurant-approval';
  static const String reservationMonitoring =
      '/reservation-monitoring';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        home: (_) => const HomeScreen(),
        restaurantDetail: (_) =>
            const RestaurantDetailScreen(),
        restaurantSearch: (_) =>
            const RestaurantSearchScreen(),
        menuDetail: (_) => const MenuDetailScreen(),
        reservationForm: (_) =>
            const ReservationFormScreen(),
        reservationHistory: (_) =>
            const ReservationHistoryScreen(),
        profile: (_) => const ProfileScreen(),
        adminDashboard: (_) =>
            const AdminDashboardScreen(),
        adminRestaurant: (_) =>
            const AdminRestaurantScreen(),
        adminMenu: (_) => const AdminMenuScreen(),
        adminReservation: (_) =>
            const AdminReservationScreen(),
        administratorDashboard: (_) =>
            const AdministratorDashboardScreen(),
        userManagement: (_) =>
            const UserManagementScreen(),
        categoryManagement: (_) =>
            const CategoryManagementScreen(),
        restaurantApproval: (_) =>
            const RestaurantApprovalScreen(),
        reservationMonitoring: (_) =>
            const ReservationMonitoringScreen(),
      };
}