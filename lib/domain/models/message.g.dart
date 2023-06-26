// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      messageText: json['messageText'] as String,
      sendBy: json['sendBy'] as String,
      type: json['type'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'messageText': instance.messageText,
      'sendBy': instance.sendBy,
      'type': instance.type,
      'time': instance.time,
    };
