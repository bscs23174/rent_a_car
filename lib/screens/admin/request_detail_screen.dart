import 'package:flutter/material.dart';
import '../../models/request_model.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Title: ${request.carTitle}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Rental Duration: ${request.duration} days'),
            const SizedBox(height: 8),
            Text('Total Price: \$${request.duration * 50}'), // You can replace 50 with car pricePerDay if available
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
                    await _firestoreService.updateRequestStatus(request.id, 'approved');
                    Navigator.pop(context);
                  },
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _firestoreService.updateRequestStatus(request.id, 'declined');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
