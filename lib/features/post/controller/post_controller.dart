import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/providers/storage_repository_provider.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils.dart';
import '../repository/post_repository.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      description: description,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      downvotes: [],
      upvotes: [],
      commentsCount: 0,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      username: user.name,
    );
    final result = await _postRepository.addPost(post);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post added successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String link}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      link: link,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      downvotes: [],
      upvotes: [],
      commentsCount: 0,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      username: user.name,
    );
    final result = await _postRepository.addPost(post);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post added successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? file}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);
    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        link: r,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        downvotes: [],
        upvotes: [],
        commentsCount: 0,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        username: user.name,
      );
      final result = await _postRepository.addPost(post);
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Post added successfully');
          Routemaster.of(context).pop();
        },
      );
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    res.fold(
      (l) => null,
      (r) => showColoredSnackBar(context, 'Deleted Successfully', Colors.red),
    );
  }
}
