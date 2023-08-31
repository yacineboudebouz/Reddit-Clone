import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/models/community_model.dart';

import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({super.key, required this.type});
  final String type;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post ${widget.type}'),
        actions: [TextButton(onPressed: sharePost, child: const Text('Share'))],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    maxLength: 30,
                    controller: titleController,
                    decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter title',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18)),
                  ),
                  const SizedBox(height: 20),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          dashPattern: const [12, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyMedium!.color!,
                          child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    ))),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter description here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18)),
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter link here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18)),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Select Community')),
                  ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const Text(
                              'You are not a member of any community');
                        }
                        return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          onChanged: (value) {
                            setState(() {
                              selectedCommunity = value;
                            });
                          },
                          items: data
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                        );
                      },
                      error: (error, tr) => ErrorText(error: error.toString()),
                      loading: () => const Loader())
                ],
              ),
            ),
    );
  }
}
