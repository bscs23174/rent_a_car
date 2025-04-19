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
            return _buildLoadingIndicator();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return _buildEmptyState();
          }

          return _buildRequestList(requests, _firestoreService, context);
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
        'No requests available.',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildRequestList(
      List<RequestModel> requests, FirestoreService firestoreService, BuildContext context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return RequestCard(
          request: request,
          onApprove: () async {
            await firestoreService.updateRequestStatus(request.id, 'approved');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Request for ${request.carTitle} approved')),
            );
          },
          onDecline: () async {
            await firestoreService.updateRequestStatus(request.id, 'declined');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Request for ${request.carTitle} declined')),
            );
          },
        );
      },
    );
  }
}
