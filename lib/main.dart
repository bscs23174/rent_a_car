import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'utils/theme.dart';
import 'utils/theme_provider.dart';
import 'screens/auth/admin_login_screen.dart';
import 'screens/dashboard/admin_home_screen.dart';
import 'screens/manage_cars/manage_cars_screen.dart';
import 'screens/manage_bookings/manage_requests_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/notifications/notification_screen.dart';
import 'screens/manage_cars/edit_car_screen.dart';
import 'screens/manage_cars/add_car_screen.dart';

import 'models/car_model.dart';
import 'models/notification_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const RentACarAdminApp(),
    ),
  );
}

class RentACarAdminApp extends StatelessWidget {
  const RentACarAdminApp({super.key});



  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Rent a Car Admin',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AdminLoginScreen.routeName,
          routes: {
            AdminLoginScreen.routeName: (context) => const AdminLoginScreen(),
            AdminHomeScreen.routeName: (context) => const AdminHomeScreen(),
            ManageCarsScreen.routeName: (context) => const ManageCarsScreen(),
            ManageRequestsScreen.routeName: (context) => const ManageRequestsScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            NotificationScreen.routeName: (context) => const NotificationScreen(),
              '/addCar': (context) => const AddCarScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/editCar') {
              final car = settings.arguments as CarModel;
              return MaterialPageRoute(
                builder: (context) => EditCarScreen(car: car),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
