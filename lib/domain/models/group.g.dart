// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      members: json['members'] as List<dynamic>,
      groupId: json['gruopId'] as String,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'members': instance.members,
      'gruopId': instance.groupId,
    };
