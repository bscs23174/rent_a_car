class RequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String carId;
  final String carTitle;
  final int duration;
  final String status;
  final String? message;

  RequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.carId,
    required this.carTitle,
    required this.duration,
    required this.status,
    this.message,
  });

  factory RequestModel.fromMap(String id, Map<String, dynamic> data) {
    return RequestModel(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      carId: data['carId'] ?? '',
      carTitle: data['carTitle'] ?? '',
      duration: data['duration'] ?? 0,
      status: data['status'] ?? 'pending',
      message: data['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'carId': carId,
      'carTitle': carTitle,
      'duration': duration,
      'status': status,
      'message': message,
    };
  }
}
