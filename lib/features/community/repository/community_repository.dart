import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_def.dart';
import 'package:reddit/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(
      firestore: ref.watch(firestoreProvider),
    ));

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required firestore}) : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community wuth the same name already exists !';
      }
      return right(
          await _communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
