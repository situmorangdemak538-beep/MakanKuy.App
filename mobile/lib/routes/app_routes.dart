import 'package:flutter/material.dart';

import 'package:makankuy/screens/admin_dashboard_screen.dart';
import 'package:makankuy/screens/admin_menu_screen.dart';
import 'package:makankuy/screens/admin_reservation_screen.dart';
import 'package:makankuy/screens/admin_restaurant_screen.dart';
import 'package:makankuy/screens/administrator_dashboard_screen.dart';
import 'package:makankuy/screens/category_management_screen.dart';
import 'package:makankuy/screens/login_screen.dart';
import 'package:makankuy/screens/profile_screen.dart';
import 'package:makankuy/screens/register_screen.dart';
import 'package:makankuy/screens/reservation_history_screen.dart';
import 'package:makankuy/screens/reservation_monitoring_screen.dart';
import 'package:makankuy/screens/restaurant_approval_screen.dart';
import 'package:makankuy/screens/splash_screen.dart';
import 'package:makankuy/screens/user_management_screen.dart';
import 'package:makankuy/screens/home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const history = '/history';
  static const profile = '/profile';

  static const adminDashboard = '/admin-dashboard';
  static const adminRestaurant = '/admin-restaurant';
  static const adminMenu = '/admin-menu';
  static const adminReservation = '/admin-reservation';

  static const administratorDashboard = '/administrator-dashboard';
  static const users = '/users';
  static const categories = '/categories';
  static const approvals = '/approvals';
  static const monitoring = '/monitoring';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        home: (_) => const HomeScreen(),
        history: (_) => const ReservationHistoryScreen(),
        profile: (_) => const ProfileScreen(),
        adminDashboard: (_) => const AdminDashboardScreen(),
        adminRestaurant: (_) => const AdminRestaurantScreen(),
        adminMenu: (_) => const AdminMenuScreen(),
        adminReservation: (_) => const AdminReservationScreen(),
        administratorDashboard: (_) =>
            const AdministratorDashboardScreen(),
        users: (_) => const UserManagementScreen(),
        categories: (_) => const CategoryManagementScreen(),
        approvals: (_) => const RestaurantApprovalScreen(),
        monitoring: (_) => const ReservationMonitoringScreen(),
      };
}