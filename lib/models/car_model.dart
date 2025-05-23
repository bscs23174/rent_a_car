// car_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String title;
  final String type;
  final String imageURL;
  final double ratePerDay;
  final String capacity;
  final bool isRecommended;
  final bool isAvailable;

  CarModel({
    required this.id,
    required this.title,
    required this.type,
    required this.imageURL,
    required this.ratePerDay,
    required this.capacity,
    required this.isRecommended,
    required this.isAvailable,
  });

  factory CarModel.fromMap(String id, Map<String, dynamic> data) {
    return CarModel(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      imageURL: data['imageURL'] ?? '',
      ratePerDay: (data['ratePerDay'] as num).toDouble(),
      capacity: data['capacity'] ?? 0,
      isRecommended: data['isRecommended'] ?? false,
      isAvailable: data['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'imageURL': imageURL,
      'ratePerDay': ratePerDay,
      'capacity': capacity,
      'isRecommended': isRecommended,
      'isAvailable': isAvailable,
    };
  }

  Future<void> save() async {
    await FirebaseFirestore.instance.collection('cars').doc(id).set(toMap());
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('cars').doc(id).delete();
  }
}
