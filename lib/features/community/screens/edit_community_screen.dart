import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit community'),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('Save'))
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          DottedBorder(
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              dashPattern: const [12, 4],
                              strokeCap: StrokeCap.round,
                              color: Pallete.darkModeAppTheme.textTheme
                                  .bodyMedium!.color!,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: community.banner.isEmpty ||
                                        community.banner ==
                                            Constants.bannerDefault
                                    ? const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      )
                                    : Image.network(community.banner),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
        error: (error, stacktrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
