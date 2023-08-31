import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/models/post_model.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_def.dart';
import '../../../models/community_model.dart';

final postRepositoryProvider = Provider((ref) => PostRepository(
      firestore: ref.watch(firestoreProvider),
    ));

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(await _posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
