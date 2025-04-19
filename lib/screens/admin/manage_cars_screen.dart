import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../widgets/car_card.dart';
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
            return _buildLoadingIndicator();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCarList(cars, _firestoreService, context);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 16),
          Text(
            'Something went wrong: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No cars available.',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildCarList(
      List<CarModel> cars, FirestoreService firestoreService, BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return Dismissible(
          key: Key(car.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await firestoreService.deleteCar(car.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${car.title} deleted')),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: CarCard(
            car: car,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/add-edit-car',
                arguments: car,
              );
            },
            onDelete: () async {
              final confirm = await _showDeleteDialog(context);
              if (confirm == true) {
                await firestoreService.deleteCar(car.id);
              }
            },
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
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
  }
}
