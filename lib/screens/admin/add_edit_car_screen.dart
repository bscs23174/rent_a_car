import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class AddEditCarScreen extends StatefulWidget {
  final CarModel? car;

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
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

    setState(() => _isLoading = true);

    final car = CarModel(
      id: widget.car?.id ?? '',
      title: _titleController.text.trim(),
      type: _typeController.text.trim(),
      pricePerDay: double.parse(_priceController.text.trim()),
      imageUrl: _imageUrlController.text.trim(),
    );

    if (widget.car == null) {
      await _firestoreService.addCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added successfully!')),
      );
    } else {
      await _firestoreService.updateCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car updated successfully!')),
      );
    }

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  Future<void> _deleteCar() async {
    if (widget.car != null) {
      await _firestoreService.deleteCar(widget.car!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car deleted')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.car != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Car' : 'Add Car'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Car'),
                    content: const Text('Are you sure you want to delete this car?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCar();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Car Title'),
                validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Car Type'),
                validator: (value) => value == null || value.isEmpty ? 'Enter type' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price Per Day'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter price';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Car Image URL'),
                onChanged: (_) => setState(() {}),
                validator: (value) => value == null || value.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Save Changes' : 'Add Car'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveCar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
