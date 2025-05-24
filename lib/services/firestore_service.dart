import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final _carsRef = FirebaseFirestore.instance.collection('cars');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CarModel>> getCars() async {
    try {
      final snapshot = await _carsRef.get();
      return snapshot.docs
          .map((doc) => CarModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }

  // Add a new notification (used by admin panel)
  Future<void> addNotification(NotificationModel notification) async {
    await _firestore.collection('notifications').add(notification.toMap());
  }

// Fetch notifications for a customer (fetch both personal and broadcast)
  Future<List<NotificationModel>> getNotificationsForCustomer(String customerId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('customerId', whereIn: [customerId, 'ALL'])
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
        .toList();
  }

// (Optional) Add raw notification without using NotificationModel
// Use this only if you're not using NotificationModel in some places
  Future<void> sendNotification(String customerId, String title, String message) async {
    await _firestore.collection('notifications').add({
      'customerId': customerId,
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


  Future<void> updateRequestFields(String id, Map<String, dynamic> data) async {
    await _firestore.collection('requests').doc(id).update(data);
  }

  Stream<List<Map<String, dynamic>>> getRequests() {
    return _firestore.collection('requests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // include the document ID for updates
        return data;
      }).toList();
    });

    // Add a new notification
    Future<void> addNotification(NotificationModel notification) async {
      await _firestore.collection('notifications').add(notification.toMap());
    }

    // Fetch notifications for a customer
    Future<List<NotificationModel>> getNotificationsForCustomer(String customerId) async {
      final snapshot = await _firestore
          .collection('notifications')
          .where('customerId', isEqualTo: customerId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
          .toList();
    }

  }

  // Update request status
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': newStatus,
    });
  }

  Future<void> addCar(CarModel car) async {
    try {
      await _carsRef.add(car.toMap());
    } catch (e) {
      print('Error adding car: $e');
    }
  }

  Future<void> updateCar(CarModel car) async {
    try {
      await _carsRef.doc(car.id).update(car.toMap());
    } catch (e) {
      print('Error updating car: $e');
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      await _carsRef.doc(id).delete();
    } catch (e) {
      print('Error deleting car: $e');
    }
  }
}
