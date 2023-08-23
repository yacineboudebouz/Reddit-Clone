// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Community {
  final String name;
  final String banner;
  final String avatar;
  final String id;
  final List<String> members;
  final List<String> mods;

  Community(
      {required this.name,
      required this.banner,
      required this.avatar,
      required this.id,
      required this.members,
      required this.mods});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'id': id,
      'members': members,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      id: map['id'] as String,
      members: List<String>.from(map['members']),
      mods: List<String>.from(map['mods']),
    );
  }

  @override
  String toString() {
    return 'Community(name: $name, banner: $banner, avatar: $avatar, id: $id, members: $members, mods: $mods)';
  }
}
