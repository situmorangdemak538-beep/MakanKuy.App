import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/restaurant_provider.dart';
import 'routes/app_routes.dart';
import 'utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MakanKuyApp());
}

class MakanKuyApp extends StatelessWidget {
  const MakanKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MakanKuy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}