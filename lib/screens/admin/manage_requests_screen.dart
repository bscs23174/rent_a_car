import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class ManageRequestsScreen extends StatefulWidget {
  static const String routeName = '/manageRequests';

  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _updateStatus(String requestId, String newStatus) async {
    await _firestoreService.updateRequestStatus(requestId, newStatus);
  }

  Widget _buildRequestList(List<Map<String, dynamic>> requests) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Text(request['userName'] ?? 'No Name', style: Theme.of(context).textTheme.titleMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Car: ${request['carTitle'] ?? 'N/A'}'),
                Text('Email: ${request['userEmail'] ?? 'N/A'}'),
                Text('Phone: ${request['contactPhone'] ?? 'N/A'}'),
                Text('Status: ${request['status'] ?? 'pending'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (request['status'] != 'approved')
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _updateStatus(request['id'], 'approved'),
                  ),
                if (request['status'] != 'disapproved')
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _updateStatus(request['id'], 'disapproved'),
                  ),
              ],
            ),
            onTap: () => _showEditDialog(request),
          ),
        );
      },
    );
  }

  void _showEditDialog(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Request Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${request['userName'] ?? 'N/A'}'),
              Text('Email: ${request['userEmail'] ?? 'N/A'}'),
              Text('Phone: ${request['contactPhone'] ?? 'N/A'}'),
              Text('Car: ${request['carTitle'] ?? 'N/A'}'),
              Text('From: ${request['startDate'] ?? 'N/A'}'),
              Text('To: ${request['endDate'] ?? 'N/A'}'),
              Text('Status: ${request['status'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Disapproved'),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data ?? [];
          final pending = requests.where((r) => r['status'] == 'pending').toList();
          final approved = requests.where((r) => r['status'] == 'approved').toList();
          final disapproved = requests.where((r) => r['status'] == 'disapproved').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRequestList(pending),
              _buildRequestList(approved),
              _buildRequestList(disapproved),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
