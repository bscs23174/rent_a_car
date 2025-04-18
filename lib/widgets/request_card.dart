import 'package:flutter/material.dart';
import '../../models/request_model.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const RequestCard({
    super.key,
    required this.request, // Ensure this is required and passed
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(request.carTitle ?? 'Car Request'),
        subtitle: Text('Status: ${request.status}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onApprove,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onDecline,
            ),
          ],
        ),
      ),
    );
  }
}
