import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  final String name;
  final String secondName;
  final String email;
  final String userImageUrl;
  List friends = [];
  List friendRequests = [];

  AppUser({
    required this.name,
    required this.secondName,
    required this.email,
    required this.userImageUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
