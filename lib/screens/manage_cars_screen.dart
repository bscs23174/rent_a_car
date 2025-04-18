import 'package:flutter/material.dart';

class ManageCarsScreen extends StatelessWidget {
  final List<String> cars = ['Honda Civic', 'Toyota Corolla', 'Ford Mustang'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Manage Cars'),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.directions_car, color: Colors.amberAccent),
              ),
              title: Text(
                cars[index],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () {
                  // TODO: Hook up delete functionality
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
