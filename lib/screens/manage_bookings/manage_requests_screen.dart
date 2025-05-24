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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _updateStatus(Map<String, dynamic> request, String newStatus) async {
    await _firestoreService.updateRequestStatus(request['id'], newStatus);

    final userId = request['userId'];
    final carTitle = request['carTitle'] ?? 'a car';

    await _firestoreService.sendNotification(
      userId,
      'Request ${newStatus.toUpperCase()}',
      'Your request for $carTitle was $newStatus.',
    );
  }

  Widget _buildRequestList(List<Map<String, dynamic>> requests) {
    final filteredRequests = requests.where((r) {
      final query = _searchQuery;
      return r['userName']?.toLowerCase().contains(query) == true ||
          r['userEmail']?.toLowerCase().contains(query) == true ||
          r['carTitle']?.toLowerCase().contains(query) == true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search by name, email, or car',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              final request = filteredRequests[index];
              return ListTile(
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
                        onPressed: () => _updateStatus(request, 'approved'),
                      ),
                    if (request['status'] != 'disapproved')
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _updateStatus(request, 'disapproved'),
                      ),
                  ],
                ),
                onTap: () => _showEditDialog(request),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showEditDialog(Map<String, dynamic> request) {
    final TextEditingController nameController = TextEditingController(text: request['userName']);
    final TextEditingController emailController = TextEditingController(text: request['userEmail']);
    final TextEditingController phoneController = TextEditingController(text: request['contactPhone']);
    final TextEditingController startDateController = TextEditingController(text: request['startDate']);
    final TextEditingController endDateController = TextEditingController(text: request['endDate']);
    String status = request['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Request'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                TextFormField(controller: startDateController, decoration: const InputDecoration(labelText: 'Start Date')),
                TextFormField(controller: endDateController, decoration: const InputDecoration(labelText: 'End Date')),
                DropdownButtonFormField<String>(
                  value: status,
                  onChanged: (value) => status = value!,
                  items: ['pending', 'approved', 'disapproved']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  'userName': nameController.text,
                  'userEmail': emailController.text,
                  'contactPhone': phoneController.text,
                  'startDate': startDateController.text,
                  'endDate': endDateController.text,
                  'status': status,
                };
                await _firestoreService.updateRequestFields(request['id'], updatedData);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
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
    _searchController.dispose();
    super.dispose();
  }
}
