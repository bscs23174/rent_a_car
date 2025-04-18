import 'package:flutter/material.dart';
import '../../models/request_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/request_card.dart';

class ManageRequestsScreen extends StatelessWidget {
  const ManageRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Requests'),
      ),
      body: StreamBuilder<List<RequestModel>>(
        stream: _firestoreService.getRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(child: Text('No requests available.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return RequestCard(
                request: request,  // Ensure you pass `request` here
                onApprove: () async {
                  await _firestoreService.updateRequestStatus(request.id, 'approved');
                },
                onDecline: () async {
                  await _firestoreService.updateRequestStatus(request.id, 'declined');
                },
              );
            },
          );
        },
      ),
    );
  }
}
