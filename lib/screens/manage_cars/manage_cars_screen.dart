import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/car_card.dart';

class ManageCarsScreen extends StatefulWidget {
  static const String routeName = '/manageCars';
  const ManageCarsScreen({super.key});

  @override
  State<ManageCarsScreen> createState() => _ManageCarsScreenState();
}

class _ManageCarsScreenState extends State<ManageCarsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CarModel> _cars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    final cars = await _firestoreService.getCars();
    setState(() {
      _cars = cars;
      _isLoading = false;
    });
  }

  Future<void> _deleteCar(String id) async {
    await _firestoreService.deleteCar(id);
    await _fetchCars();
  }

  void _navigateToEdit(CarModel car) async {
    await Navigator.pushNamed(
      context,
      '/editCar',
      arguments: car,
    );
    await _fetchCars(); // Refresh on return
  }

  void _navigateToAddCar() async {
    await Navigator.pushNamed(context, '/addCar');
    await _fetchCars(); // Refresh on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cars'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cars.isEmpty
          ? const Center(child: Text('No cars found.'))
          : ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          return CarCard(
            car: car,
            onTap: () => _navigateToEdit(car),
            onDelete: () => _deleteCar(car.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCar,
        child: const Icon(Icons.add),
      ),
    );
  }
}
