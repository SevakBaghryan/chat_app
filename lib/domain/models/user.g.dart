// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      name: json['name'] as String,
      secondName: json['secondName'] as String,
      email: json['email'] as String,
      userImageUrl: json['userImageUrl'] as String,
    )
      ..friends = json['friends'] as List<dynamic>
      ..friendRequests = json['friendRequests'] as List<dynamic>;

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'name': instance.name,
      'secondName': instance.secondName,
      'email': instance.email,
      'userImageUrl': instance.userImageUrl,
      'friends': instance.friends,
      'friendRequests': instance.friendRequests,
    };
