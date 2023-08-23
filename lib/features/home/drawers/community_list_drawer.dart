import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});
  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create_community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create community'),
              leading: const Icon(Icons.add),
              onTap: () {
                navigateToCreateCommunity(context);
              },
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (comunnities) {
                    return Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final community = comunnities[index];
                          return ListTile(
                            title: Text('r/${community.name}'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            onTap: () {},
                          );
                        },
                        itemCount: comunnities.length,
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
