import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ───── Cars ─────────────────────

  Stream<List<CarModel>> getCars() {
    return _db.collection('cars').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CarModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> addCar(CarModel car) async {
    await _db.collection('cars').add(car.toMap());
  }

  Future<void> updateCar(CarModel car) async {
    await _db.collection('cars').doc(car.id).update(car.toMap());
  }

  Future<void> deleteCar(String id) async {
    await _db.collection('cars').doc(id).delete();
  }

  // ───── Requests (Map-based) ─────────────────────

  Stream<List<Map<String, dynamic>>> getRequests() {
    return _db.collection('requests').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addRequest(Map<String, dynamic> request) async {
    await _db.collection('requests').add(request);
  }

  Future<void> updateRequest(String id, Map<String, dynamic> updatedRequest) async {
    await _db.collection('requests').doc(id).update(updatedRequest);
  }

  Future<void> deleteRequest(String id) async {
    await _db.collection('requests').doc(id).delete();
  }

  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    await _db.collection('requests').doc(requestId).update({'status': newStatus});
  }

  Future<Map<String, dynamic>?> getRequestById(String id) async {
    final doc = await _db.collection('requests').doc(id).get();
    if (doc.exists) {
      final data = doc.data();
      data?['id'] = doc.id;
      return data;
    }
    return null;
  }

  // ───── Car Details ─────────────────────

  Future<CarModel> getCarDetails(String requestId) async {
    final requestDoc = await _db.collection('requests').doc(requestId).get();
    if (!requestDoc.exists) {
      throw Exception('Request not found');
    }

    final requestData = requestDoc.data()!;
    final carId = requestData['carId'];

    final carDoc = await _db.collection('cars').doc(carId).get();
    if (!carDoc.exists) {
      throw Exception('Car not found');
    }

    return CarModel.fromMap(carDoc.id, carDoc.data()!);
  }
}
