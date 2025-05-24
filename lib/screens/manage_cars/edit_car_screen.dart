import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class EditCarScreen extends StatefulWidget {
  final CarModel car;

  const EditCarScreen({super.key, required this.car});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  late final TextEditingController _titleController;
  late final TextEditingController _typeController;
  late final TextEditingController _capacityController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;

  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    _titleController = TextEditingController(text: car.title);
    _typeController = TextEditingController(text: car.type);
    _capacityController = TextEditingController(text: car.capacity);
    _priceController = TextEditingController(text: car.ratePerDay.toString());
    _imageUrlController = TextEditingController(text: car.imageUrl);
    _isAvailable = car.available;
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedCar = widget.car.copyWith(
        title: _titleController.text.trim(),
        type: _typeController.text.trim(),
        capacity: _capacityController.text.trim(),
        ratePerDay: double.tryParse(_priceController.text.trim()) ?? 0.0,
        imageUrl: _imageUrlController.text.trim(),
        available: _isAvailable,
      );

      await _firestoreService.updateCar(updatedCar);

      if (mounted) Navigator.pop(context);
    }
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        bool isNumber = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Car')),
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
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
