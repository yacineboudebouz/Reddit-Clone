import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  const AddModsScreen({super.key, required this.name});
  final String name;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  Set<String> uids = {};
  int ctr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: saveMods, icon: const Icon(Icons.done))
        ],
      ),
      body: ref.watch(getCommunityNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
                itemBuilder: (context, index) {
                  if (ctr == 0) {
                    for (var member in community.members) {
                      if (community.mods.contains(member)) {
                        uids.add(member);
                      }
                    }
                    ctr++;
                  }
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader());
                },
                itemCount: community.members.length,
              ),
          error: (error, traceeeror) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
