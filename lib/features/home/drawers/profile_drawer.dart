import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'u/${user.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            title: const Text('My Profile'),
            leading: const Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () {
              logOut(ref);
            },
          ),
          Switch(
              value: true,
              onChanged: (value) {
                value = !value;
              }),
        ],
      )),
    );
  }
}
