import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';
import '../models/request_model.dart';

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

  // ───── Requests ─────────────────────

  Stream<List<RequestModel>> getRequests() {
    return _db.collection('requests').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RequestModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> addRequest(RequestModel request) async {
    await _db.collection('requests').add(request.toMap());
  }

  Future<void> updateRequest(RequestModel request) async {
    await _db.collection('requests').doc(request.id).update(request.toMap());
  }

  Future<void> deleteRequest(String id) async {
    await _db.collection('requests').doc(id).delete();
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await _db.collection('requests').doc(id).update({'status': status});
  }

  Future<RequestModel?> getRequestById(String id) async {
    final doc = await _db.collection('requests').doc(id).get();
    if (doc.exists) {
      return RequestModel.fromMap(doc.id, doc.data()!);
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
    final carId = requestData['carId'];  // Assuming carId is stored in the request document

    final carDoc = await _db.collection('cars').doc(carId).get();
    if (!carDoc.exists) {
      throw Exception('Car not found');
    }

    final carData = carDoc.data()!;
    return CarModel.fromMap(carDoc.id, carData);
  }
}
