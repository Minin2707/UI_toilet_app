class ToiletDto {
  final String id;
  final String title;
  final String description;
  final String address;
  final String status;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final String accessType;
  final bool wheelchairAccessible;

  const ToiletDto({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.accessType,
    required this.wheelchairAccessible,
  });

  factory ToiletDto.fromJson(Map<String, dynamic> json) {
    print(json);
    return ToiletDto(
      id: json['id'],
      title: json['title'],
      description:
          json['description'] ?? '',
      address:
          json['address'] ?? '',
      status: json['status'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      accessType:
          json['accessType'] ?? 'FREE',

      wheelchairAccessible:
          json['wheelchairAccessible'] ?? false,
    );
  }
}