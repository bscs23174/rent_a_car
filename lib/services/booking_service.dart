// booking_service.dart:

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  static final _bookingsRef = FirebaseFirestore.instance.collection('bookings');

  static Future<List<Booking>> getBookingsByCustomer(String customerId) async {
    final snapshot = await _bookingsRef.where('customerId', isEqualTo: customerId).get();
    return snapshot.docs.map((doc) => Booking.fromMap(doc.id, doc.data())).toList();
  }

  static Future<Booking?> getBookingById(String id) async {
    final doc = await _bookingsRef.doc(id).get();
    if (doc.exists) return Booking.fromMap(doc.id, doc.data()!);
    return null;
  }

  static Future<void> createBooking(Booking booking) async {
    await _bookingsRef.doc(booking.id).set(booking.toMap());
  }

  static Future<void> updateBookingStatus(String id, BookingStatus status) async {
    await _bookingsRef.doc(id).update({'status': bookingStatusToString(status)});
  }

  static Future<void> addReview(String bookingId, Review review) async {
    await _bookingsRef.doc(bookingId).update({'review': review.toMap()});
  }

  static Future<void> deleteBooking(String id) async {
    await _bookingsRef.doc(id).delete();
  }

  static Future<List<Booking>> getAllBookings() async {
    final snapshot = await _bookingsRef.get();
    return snapshot.docs.map((doc) => Booking.fromMap(doc.id, doc.data())).toList();
  }
}