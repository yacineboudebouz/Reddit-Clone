import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/features/post/widgets/comment_card.dart';

import '../../../models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(post: data),
                TextField(
                  onSubmitted: (value) => addComment(data),
                  controller: commentController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      hintText: 'What are your thoughts ?'),
                ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final comment = data[index];
                            return CommentCard(comment: comment);
                          },
                          itemCount: data.length,
                        ),
                      );
                    },
                    error: (e, t) => ErrorText(error: e.toString()),
                    loading: () => const Loader())
              ],
            );
          },
          error: (error, errortrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
