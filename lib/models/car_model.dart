class CarModel {
  final String id;
  final String title;
  final String type;
  final double pricePerDay;
  final String imageUrl;
  final String capacity;
  final String createdBy;
  final bool available;

  CarModel({
    required this.id,
    required this.title,
    required this.type,
    required this.pricePerDay,
    required this.imageUrl,
    required this.capacity,
    required this.createdBy,
    required this.available,
  });

  factory CarModel.fromMap(String id, Map<String, dynamic> data) {
    return CarModel(
      id: id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      pricePerDay: (data['pricePerDay'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      capacity: data['capacity'] ?? '',
      createdBy: data['createdBy'] ?? '',
      available: data['available'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'capacity': capacity,
      'createdBy': createdBy,
      'available': available,
    };
  }
}
