import 'package:grocery_app/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String number;

  UserModel({this.id, required this.number});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel.fromJson({...json, 'id': id});
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(number: entity.phoneNumber);
  }

  UserEntity toEntity() {
    return UserEntity(phoneNumber: number);
  }
}
