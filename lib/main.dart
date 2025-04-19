import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart'; // For elegant fonts
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/manage_cars_screen.dart';
import 'screens/admin/manage_requests_screen.dart';
import 'screens/admin/add_edit_car_screen.dart';
import 'screens/admin/request_detail_screen.dart';
import 'screens/admin/profile_screen.dart';
import 'package:rent_a_car/models/request_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RentACarAdminApp());
}

class RentACarAdminApp extends StatelessWidget {
  const RentACarAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent a Car Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: GoogleFonts.poppinsTextTheme(), // Clean, modern font
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(), // Smooth iOS-style transitions
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/adminLogin',
      routes: {
        '/adminLogin': (context) => const AdminLoginScreen(),
        '/adminHome': (context) => const AdminHomeScreen(),
        '/manageCars': (context) => const ManageCarsScreen(),
        '/manageRequests': (context) => const ManageRequestsScreen(),
        '/add-edit-car': (context) => const AddEditCarScreen(),
        '/requestDetail': (context) {
          final request = ModalRoute.of(context)!.settings.arguments as RequestModel;
          return RequestDetailScreen(request: request);
        },
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
