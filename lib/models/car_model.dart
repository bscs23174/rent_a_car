class CarModel {
  final String id;
  final String title;
  final String type;
  final String capacity;
  final String imageUrl;
  final double ratePerDay;
  final bool available;
  final String createdBy;

  CarModel({
    this.id = '',
    required this.title,
    required this.type,
    required this.capacity,
    required this.imageUrl,
    required this.ratePerDay,
    required this.available,
    required this.createdBy,
  });
  CarModel copyWith({
    String? id,
    String? title,
    String? type,
    String? capacity,
    double? ratePerDay,
    String? imageUrl,
    String? createdBy,
    bool? available,
  }) {
    return CarModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      ratePerDay: ratePerDay ?? this.ratePerDay,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      available: available ?? this.available,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'capacity': capacity,
      'imageUrl': imageUrl,
      'ratePerDay': ratePerDay,
      'available': available,
      'createdBy': createdBy,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return CarModel(
      id: id ?? map['id'],
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      capacity: map['capacity'] ?? '',
      ratePerDay: (map['ratePerDay'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      createdBy: map['createdBy'] ?? '',
      available: map['available'] ?? true,
    );
  }
}
