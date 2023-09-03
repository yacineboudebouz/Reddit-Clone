// ignore_for_file: public_member_api_docs, sort_constructors_first

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;

  Comment(
      {required this.id,
      required this.text,
      required this.createdAt,
      required this.postId,
      required this.username,
      required this.profilePic});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.microsecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
    );
  }
}
