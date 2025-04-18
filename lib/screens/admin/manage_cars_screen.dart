import 'package:flutter/material.dart';
import '../../models/car_model.dart'; // Ensure this import
import '../../widgets/car_card.dart'; // Add this import to use CarCard
import '../../services/firestore_service.dart';

class ManageCarsScreen extends StatelessWidget {
  const ManageCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-edit-car');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CarModel>>(
        stream: _firestoreService.getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return const Center(child: Text('No cars available.'));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return CarCard(
                car: car,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/add-edit-car',
                    arguments: car,
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Car'),
                      content: const Text('Are you sure you want to delete this car?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _firestoreService.deleteCar(car.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
