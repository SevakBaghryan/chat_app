import 'package:json_annotation/json_annotation.dart';

part 'group_member.g.dart';

@JsonSerializable()
class GroupMember {
  final String uid;
  final String name;
  final String email;
  final String userImageUrl;
  final bool isAdmin;

  GroupMember({
    required this.uid,
    required this.userImageUrl,
    required this.email,
    required this.name,
    required this.isAdmin,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberToJson(this);
}
