import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/firebase_constants.dart';

import '../../../../core/providers/firebase_providers.dart';

final postRepositoryProvider = Provider((ref) => PostRepository(
      firestore: ref.watch(firestoreProvider),
    ));

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
