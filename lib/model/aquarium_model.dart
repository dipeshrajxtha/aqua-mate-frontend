class Aquarium {
  final String? id;
  final String name;
  final String aquariumType;
  final double tankSize;
  final String tankShape;
  final double temperature;
  final String location;
  final String description;

  Aquarium({
    this.id,
    required this.name,
    required this.aquariumType,
    required this.tankSize,
    required this.tankShape,
    required this.temperature,
    required this.location,
    required this.description,
  });

  factory Aquarium.fromJson(Map<String, dynamic> json) {
    return Aquarium(
      id: json['_id'],
      name: json['name'] ?? '',
      aquariumType: json['aquariumType'] ?? '',
      tankSize: (json['tankSize'] ?? 0).toDouble(),
      tankShape: json['tankShape'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "aquariumType": aquariumType,
      "tankSize": tankSize,
      "tankShape": tankShape,
      "temperature": temperature,
      "location": location,
      "description": description,
    };
  }
}
