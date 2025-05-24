import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isAvailable = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final car = CarModel(
        id: '', // Firestore will generate ID
        title: _titleController.text.trim(),
        type: _typeController.text.trim(),
        capacity: _capacityController.text.trim(),
        ratePerDay: double.tryParse(_priceController.text.trim()) ?? 0,
        imageUrl: _imageUrlController.text.trim(),
        available: _isAvailable,
        createdBy: 'admin@company.com',
      );

      await _firestoreService.addCar(car);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Car')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Car Title'),
              const SizedBox(height: 12),
              _buildTextField(_typeController, 'Car Type'),
              const SizedBox(height: 12),
              _buildTextField(_capacityController, 'Capacity'),
              const SizedBox(height: 12),
              _buildTextField(_priceController, 'Price Per Day', isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(_imageUrlController, 'Image URL'),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) =>
      (value == null || value.trim().isEmpty) ? 'Enter $label' : null,
    );
  }
}
