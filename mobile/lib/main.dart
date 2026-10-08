import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/nav_provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/restaurant_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),        
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),        
        ChangeNotifierProvider(create: (_) => MenuProvider()),        
        ChangeNotifierProvider(create: (_) => ReservationProvider()),        
      ],
      child: const MakanKuyApp(),
    ),
  );
}

class MakanKuyApp extends StatelessWidget {
    const MakanKuyApp({super.key});
  @override
    Widget build(BuildContext context) {  
      return MaterialApp(   
      title: 'MakanKuy',      
      debugShowCheckedModeBanner: false,      
      theme: AppTheme.light,      
      home: const SplashScreen(),
    );
  }
}