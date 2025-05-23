import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/firestore_service.dart';

class ManageCarsScreen extends StatefulWidget {
  static const String routeName = '/manageCars';

  const ManageCarsScreen({super.key});

  @override
  State<ManageCarsScreen> createState() => _ManageCarsScreenState();
}

class _ManageCarsScreenState extends State<ManageCarsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCapacity = '4';
  bool _available = true;

  final List<String> _capacityOptions = ['2', '4', '5', '8', '10'];

  CarModel? _editingCar;
  bool _isLoading = false;

  void _showCarForm({CarModel? car}) {
    if (car != null) {
      _editingCar = car;
      _titleController.text = car.title;
      _typeController.text = car.type;
      _priceController.text = car.ratePerDay.toString();
      _imageUrlController.text = car.imageURL;
      _selectedCapacity = _capacityOptions.contains(car.capacity) ? car.capacity : '4';
      _available = car.isAvailable;
    } else {
      _editingCar = null;
      _titleController.clear();
      _typeController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      _selectedCapacity = '4';
      _available = true;
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
                  _editingCar != null ? 'Edit Car' : 'Add New Car',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 20),
              if (_imageUrlController.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageUrlController.text,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCapacity,
                decoration: const InputDecoration(labelText: 'Capacity'),
                items: _capacityOptions.map((capacity) {
                  return DropdownMenuItem<String>(
                    value: capacity,
                    child: Text('$capacity Seater'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCapacity = value!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Select capacity' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _saveCar,
                icon: Icon(_editingCar != null ? Icons.save : Icons.add),
                label: Text(_editingCar != null ? 'Save Changes' : 'Add Car'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              if (_editingCar != null)
                TextButton(
                  onPressed: () async {
                    await _firestoreService.deleteCar(_editingCar!.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Car deleted')),
                    );
                  },
                  child: const Text('Delete Car', style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String createdBy = 'admin@company.com';

    final car = CarModel(
      id: _editingCar?.id ?? '',
      title: _titleController.text.trim(),
      type: _typeController.text.trim(),
      ratePerDay: double.parse(_priceController.text.trim()),
      imageURL: _imageUrlController.text.trim(),
      capacity: _selectedCapacity,
      isAvailable: _available,
      isRecommended: false,
    );

    if (_editingCar == null) {
      await _firestoreService.addCar(car);
    } else {
      await _firestoreService.updateCar(car);
    }

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Cars'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCarForm(),
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
                    const Icon(Icons.directions_car, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Tap a car to edit or swipe to delete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<CarModel>>(
                  stream: _firestoreService.getCars(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final cars = snapshot.data ?? [];

                    if (cars.isEmpty) {
                      return const Center(
                        child: Text(
                          'No cars available. Add some to get started!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                car.imageURL,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              car.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text('${car.type} - \$${car.ratePerDay.toStringAsFixed(2)} / day'),
                            trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                            onTap: () => _showCarForm(car: car),
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
