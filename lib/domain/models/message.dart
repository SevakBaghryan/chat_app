import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String messageText;
  final String sendBy;
  final String type;
  final String time;

  Message({
    required this.messageText,
    required this.sendBy,
    required this.type,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
