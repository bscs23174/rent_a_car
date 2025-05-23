import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'utils/theme.dart';
import 'utils/theme_provider.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/manage_cars_screen.dart';
import 'screens/admin/manage_requests_screen.dart';
import 'screens/admin/profile_screen.dart';

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
          },
        );
      },
    );
  }
}
