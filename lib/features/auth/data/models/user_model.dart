import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String number;
  final double? latitude;
  final double? longitude;
  final String? address;

  UserModel({
    required this.id,
    required this.number,
    this.latitude,
    this.longitude,
    this.address,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel.fromJson({...json, 'id': id});
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      number: entity.phoneNumber,
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: number,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }
}
