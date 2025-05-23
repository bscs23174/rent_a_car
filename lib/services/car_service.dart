// car_service.dart:

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarService {
  static final _carsRef = FirebaseFirestore.instance.collection('cars');

  static Future<List<CarModel>> getAllCars() async {
    final snapshot = await _carsRef.get();
    return snapshot.docs.map((doc) => CarModel.fromMap(doc.id, doc.data())).toList();
  }

  static Future<CarModel?> getCarById(String id) async {
    final doc = await _carsRef.doc(id).get();
    if (doc.exists) return CarModel.fromMap(doc.id, doc.data()!);
    return null;
  }

  static Future<void> addCar(CarModel car) async {
    await _carsRef.doc(car.id).set(car.toMap());
  }

  static Future<void> updateCar(CarModel car) async {
    await _carsRef.doc(car.id).update(car.toMap());
  }

  static Future<void> deleteCar(String id) async {
    await _carsRef.doc(id).delete();
  }
}