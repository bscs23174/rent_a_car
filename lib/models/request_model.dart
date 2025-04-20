class RequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String contactPhone;
  final String carId;
  final String carTitle;
  final String startDate;
  final String endDate;
  final String status;
  final int timestamp;
  final String? message;
  final double? pricePerDay;  // Optional field
  final String? carType;      // Optional field

  RequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.contactPhone,
    required this.carId,
    required this.carTitle,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.timestamp,
    this.message,
    this.pricePerDay,
    this.carType,
  });

  factory RequestModel.fromMap(String id, Map<String, dynamic> data) {
    return RequestModel(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['requester name'] ?? '',
      userEmail: data['userEmail'] ?? '',
      contactPhone: data['contactPhone'] ?? '',
      carId: data['carId'] ?? '',
      carTitle: data['carTitle'] ?? '',
      startDate: data['startDate'] ?? '',
      endDate: data['endDate'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? 0,
      message: data['message'],
      pricePerDay: data['pricePerDay'] != null ? data['pricePerDay'].toDouble() : null,
      carType: data['carType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'requester name': userName,
      'userEmail': userEmail,
      'contactPhone': contactPhone,
      'carId': carId,
      'carTitle': carTitle,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'timestamp': timestamp,
      'message': message,
      'pricePerDay': pricePerDay,
      'carType': carType,
    };
  }
}
