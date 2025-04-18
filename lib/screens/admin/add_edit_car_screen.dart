import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class AddEditCarScreen extends StatefulWidget {
  final CarModel? car; // Car passed if editing an existing car

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _titleController.text = widget.car!.title;
      _typeController.text = widget.car!.type;
      _priceController.text = widget.car!.pricePerDay.toString();
      _imageUrlController.text = widget.car!.imageUrl;
    }
  }

  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final car = CarModel(
      id: widget.car?.id ?? '', // If editing, keep existing ID
      title: _titleController.text.trim(),
      type: _typeController.text.trim(),
      pricePerDay: double.parse(_priceController.text.trim()),
      imageUrl: _imageUrlController.text.trim(),
    );

    if (widget.car == null) {
      // Add new car
      await _firestoreService.addCar(car);
    } else {
      // Update existing car
      await _firestoreService.updateCar(car);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car == null ? 'Add Car' : 'Edit Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Car Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Car Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price Per Day'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Car Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveCar,
                child: Text(widget.car == null ? 'Add Car' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
