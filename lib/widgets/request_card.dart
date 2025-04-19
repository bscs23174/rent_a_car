import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/request_model.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const RequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.directions_car, size: 40, color: Colors.indigo),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.carTitle ?? 'Car Request',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${request.status}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                  onPressed: onApprove,
                  tooltip: 'Approve',
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  onPressed: onDecline,
                  tooltip: 'Decline',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
