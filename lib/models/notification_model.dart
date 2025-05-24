class NotificationModel {
  final String id;
  final String customerId;
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.customerId,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      customerId: map['customerId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
