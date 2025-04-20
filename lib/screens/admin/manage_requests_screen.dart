import 'package:flutter/material.dart';
import '../../models/request_model.dart';
import '../../services/firestore_service.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _carIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _statusController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _pricePerDayController = TextEditingController();
  final _carTypeController = TextEditingController();
  final _contactPhoneController = TextEditingController();  // Added this for contact phone
  final _carTitleController = TextEditingController(); // Added this for car title

  RequestModel? _editingRequest;
  bool _isLoading = false;

  void _showRequestForm({RequestModel? request}) {
    if (request != null) {
      _editingRequest = request;
      _carIdController.text = request.carId;
      _userNameController.text = request.userName;
      _userEmailController.text = request.userEmail;
      _statusController.text = request.status;
      _startDateController.text = request.startDate;
      _endDateController.text = request.endDate;
      _pricePerDayController.text = request.pricePerDay?.toString() ?? '';
      _carTypeController.text = request.carType ?? '';
      _contactPhoneController.text = request.contactPhone;  // Set the contact phone
      _carTitleController.text = request.carTitle; // Set the car title
    } else {
      _editingRequest = null;
      _carIdController.clear();
      _userNameController.clear();
      _userEmailController.clear();
      _statusController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _pricePerDayController.clear();
      _carTypeController.clear();
      _contactPhoneController.clear();  // Clear contact phone field
      _carTitleController.clear();  // Clear car title field
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  _editingRequest != null ? 'Edit Request' : 'Add New Request',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _carIdController,
                decoration: const InputDecoration(labelText: 'Car ID'),
                validator: (value) => value == null || value.isEmpty ? 'Enter car ID' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'User Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter user name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userEmailController,
                decoration: const InputDecoration(labelText: 'User Email'),
                validator: (value) => value == null || value.isEmpty ? 'Enter user email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactPhoneController,  // Added field for contact phone
                decoration: const InputDecoration(labelText: 'Contact Phone'),
                validator: (value) => value == null || value.isEmpty ? 'Enter contact phone' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _carTitleController,  // Added field for car title
                decoration: const InputDecoration(labelText: 'Car Title'),
                validator: (value) => value == null || value.isEmpty ? 'Enter car title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) => value == null || value.isEmpty ? 'Enter status' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                validator: (value) => value == null || value.isEmpty ? 'Enter start date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
                validator: (value) => value == null || value.isEmpty ? 'Enter end date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pricePerDayController,
                decoration: const InputDecoration(labelText: 'Price per Day'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _carTypeController,
                decoration: const InputDecoration(labelText: 'Car Type'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _saveRequest,
                icon: Icon(_editingRequest != null ? Icons.save : Icons.add),
                label: Text(_editingRequest != null ? 'Save Changes' : 'Add Request'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              if (_editingRequest != null)
                TextButton(
                  onPressed: () async {
                    await _firestoreService.deleteRequest(_editingRequest!.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request deleted')),
                    );
                  },
                  child: const Text('Delete Request', style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = RequestModel(
      id: _editingRequest?.id ?? '',  // Empty string if creating a new request
      userId: 'user123',  // Change to actual user ID if needed
      userName: _userNameController.text.trim(),
      userEmail: _userEmailController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),  // Ensure this is passed
      carId: _carIdController.text.trim(),
      carTitle: _carTitleController.text.trim(),  // Ensure this is passed
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      status: _statusController.text.trim(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      message: '',  // Optional field, can be left empty or used
      pricePerDay: _pricePerDayController.text.isNotEmpty
          ? double.tryParse(_pricePerDayController.text.trim())
          : null,  // Optional
      carType: _carTypeController.text.trim(),  // Optional
    );

    if (_editingRequest == null) {
      await _firestoreService.addRequest(request);
    } else {
      await _firestoreService.updateRequest(request);
    }

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Requests'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showRequestForm(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.request_page, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Tap a request to edit or swipe to delete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<RequestModel>>(
                  stream: _firestoreService.getRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final requests = snapshot.data ?? [];

                    if (requests.isEmpty) {
                      return const Center(
                        child: Text(
                          'No requests available. Add some to get started!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

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
                            title: Text(
                              request.userName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text('Status: ${request.status}'),
                            trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                            onTap: () => _showRequestForm(request: request),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
