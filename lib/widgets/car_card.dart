import 'package:flutter/material.dart';
import '../../models/car_model.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(car.title),
        subtitle: Text('Price: \$${car.pricePerDay} / day'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
