// screens/admin/notification_screen.dart

import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/firestore_service.dart';

bool _isBroadcast = false;

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _firestoreService = FirestoreService();

  void _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      final notification = NotificationModel(
        id: '', // Firestore will auto-generate
        customerId: _customerIdController.text.trim(),
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _firestoreService.addNotification(notification);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification sent')),
        );
        _titleController.clear();
        _messageController.clear();
        _customerIdController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter Customer ID' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (val) =>
                val == null || val.trim().isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Send to all customers'),
                value: _isBroadcast,
                onChanged: (val) => setState(() => _isBroadcast = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendNotification,
                child: const Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
