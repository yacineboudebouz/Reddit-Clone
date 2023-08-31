import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';

import '../../core/common/loader.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userCommunitiesProvider).when(
        data: (data) => ref.watch(userPostsProvider(data)).when(
            data: (posts) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: PostCard(post: post),
                    );
                  });
            },
            error: (error, tc) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader()),
        error: (error, tc) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
