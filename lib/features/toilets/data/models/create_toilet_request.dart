class CreateToiletRequest {

  final String title;

  final String? description;

  final double latitude;

  final double longitude;

  final String? address;

  final String accessType;

  final bool wheelchairAccessible;

  const CreateToiletRequest({
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.accessType,
    required this.wheelchairAccessible,

    this.description,
    this.address,
  });

  Map<String, dynamic> toJson() {

    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'accessType': accessType,

      'wheelchairAccessible':
          wheelchairAccessible,
    };
  }
}