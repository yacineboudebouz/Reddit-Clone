import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/theme/pallete.dart';

import '../../features/auth/controller/auth_controller.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16)
                            .copyWith(right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          post.communityProfilePic),
                                      radius: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'r/${post.username}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => deletePost(ref, context),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      upvotePost(ref);
                                    },
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    )),
                                Text(
                                  '${post.upvotes.length - post.downvotes.length == 0 ? 'vote' : post.upvotes.length - post.downvotes.length}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                IconButton(
                                    onPressed: () {
                                      downvotePost(ref);
                                    },
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.comment)),
                                Text(
                                  '${post.commentsCount == 0 ? 'comment' : post.commentsCount}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
