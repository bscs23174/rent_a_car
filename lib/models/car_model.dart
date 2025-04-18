class Car {
  String id;
  String name;
  String imageUrl;
  double pricePerDay;

  Car({required this.id, required this.name, required this.imageUrl, required this.pricePerDay});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "imageUrl": imageUrl, "pricePerDay": pricePerDay};
  }

  static Car fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      pricePerDay: map['pricePerDay'],
    );
  }
}
