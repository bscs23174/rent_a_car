import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/manage_cars_screen.dart';
import 'screens/admin/manage_requests_screen.dart';
import 'screens/admin/add_edit_car_screen.dart';
import 'screens/admin/request_detail_screen.dart';
import 'screens/admin/profile_screen.dart';
import 'package:rent_a_car/models/request_model.dart'; // Adjust the path if necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RentACarAdminApp());
}

class RentACarAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent a Car Admin',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/adminLogin',
      routes: {
        '/adminLogin': (context) => const AdminLoginScreen(),
        '/adminHome': (context) => const AdminHomeScreen(),
        '/manageCars': (context) => const ManageCarsScreen(),
        '/manageRequests': (context) => const ManageRequestsScreen(),
        '/add-edit-car': (context) => const AddEditCarScreen(),
        '/requestDetail': (context) {
          final RequestModel request = ModalRoute.of(context)!.settings.arguments as RequestModel;
          return RequestDetailScreen(request: request);
        },
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
