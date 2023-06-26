// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => GroupMember(
      uid: json['uid'] as String,
      userImageUrl: json['userImageUrl'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool,
    );

Map<String, dynamic> _$GroupMemberToJson(GroupMember instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'userImageUrl': instance.userImageUrl,
      'isAdmin': instance.isAdmin,
    };
