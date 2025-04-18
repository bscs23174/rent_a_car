import 'package:flutter/material.dart';
import 'add_car_screen.dart';
import 'manage_cars_screen.dart';
import 'manage_bookings_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardButton('Add Car', AddCarScreen()),
              SizedBox(height: 20),
              DashboardButton('Manage Cars', ManageCarsScreen()),
              SizedBox(height: 20),
              DashboardButton('View Requests', ManageBookingsScreen()),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String title;
  final Widget screen;

  DashboardButton(this.title, this.screen);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Text(title),
      ),
    );
  }
}
