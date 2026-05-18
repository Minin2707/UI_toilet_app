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
  final int cleanCount;
  final int dirtyCount;
  final int hasPaperCount;
  final int warmCount;
  final int safeCount;
  final int confirmationCount;
  final String? lastConfirmedAt;

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
    required this.cleanCount,
    required this.dirtyCount,
    required this.hasPaperCount,
    required this.warmCount,
    required this.safeCount,
    required this.confirmationCount,
    required this.lastConfirmedAt,
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

      cleanCount:
          json['cleanCount'] ?? 0,

      dirtyCount:
          json['dirtyCount'] ?? 0,

      hasPaperCount:
          json['hasPaperCount'] ?? 0,

      warmCount:
          json['warmCount'] ?? 0,

      safeCount:
          json['safeCount'] ?? 0,

      confirmationCount:
          json['confirmationCount'] ?? 0,

      lastConfirmedAt:
           json['lastConfirmedAt'],
    );
  }
}