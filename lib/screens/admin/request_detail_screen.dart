import 'package:flutter/material.dart';
import '../../models/request_model.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class RequestDetailScreen extends StatelessWidget {
  final RequestModel request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: FutureBuilder<CarModel>(
        future: _firestoreService.getCarDetails(request.id), // Use the car ID from the request to fetch car details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Car details not found.'));
          }

          final car = snapshot.data!;
          final double totalPrice = request.duration * car.pricePerDay;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (car.imageUrl != null)
                  Image.network(car.imageUrl!), // Display car image
                const SizedBox(height: 16),
                Text(
                  'Car Title: ${car.title}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Rental Duration: ${request.duration} days'),
                const SizedBox(height: 8),
                Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'), // Calculate and display total price
                const SizedBox(height: 16),
                Text('User Name: ${request.userName}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('User Contact: ${request.userEmail}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Approve Request'),
                            content: const Text('Are you sure you want to approve this request?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _firestoreService.updateRequestStatus(request.id, 'approved');
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Decline Request'),
                            content: const Text('Are you sure you want to decline this request?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Decline'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _firestoreService.updateRequestStatus(request.id, 'declined');
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Decline'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
