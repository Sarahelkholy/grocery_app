class UserEntity {
  final String id;
  final String phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? address;

  UserEntity({
    required this.id,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
  });

  UserEntity copyWith({double? latitude, double? longitude, String? address}) {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}
