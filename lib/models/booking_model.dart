// booking_model.dart

class Review {
  final int rating; // from 1 to 5
  final String comment;

  Review({
    required this.rating,
    required this.comment,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }
}

enum BookingStatus {
  pending,
  confirmed,
  ongoing,
  completed,
  cancelled,
}

BookingStatus bookingStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return BookingStatus.pending;
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'ongoing':
      return BookingStatus.ongoing;
    case 'completed':
      return BookingStatus.completed;
    case 'cancelled':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.pending;
  }
}

String bookingStatusToString(BookingStatus status) {
  return status.toString().split('.').last;
}

class Booking {
  final String id;
  final String carId;
  final String customerId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final BookingStatus status;
  final Review? review;

  Booking({
    required this.id,
    required this.carId,
    required this.customerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.review,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      id: id,
      carId: data['carId'] ?? '',
      customerId: data['customerId'] ?? '',
      startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(data['endDate'] ?? '') ?? DateTime.now(),
      totalPrice: (data['totalPrice'] as num).toDouble(),
      status: bookingStatusFromString(data['status'] ?? 'pending'),
      review: data['review'] != null ? Review.fromMap(data['review']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'customerId': customerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalPrice': totalPrice,
      'status': bookingStatusToString(status),
      'review': review?.toMap(),
    };
  }
}

