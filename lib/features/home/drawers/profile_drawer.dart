import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
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
            onTap: () {
              navigateToProfile(context, user.uid);
            },
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
          AnimatedToggleSwitch.dual(
            current: ref.watch(themeNotifierProvider.notifier).mode ==
                ThemeMode.dark,
            first: false,
            second: true,
            borderWidth: 2.0,
            borderColor: ref.watch(themeNotifierProvider).highlightColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1.5),
              ),
            ],
            onChanged: (mode) {
              toggleTheme(ref);
            },
            colorBuilder: (b) => b ? Colors.red : Colors.green,
            iconBuilder: (value) => value
                ? const Icon(Icons.nightlight_round)
                : const Icon(Icons.sunny),
            textBuilder: (value) => value
                ? const Center(child: Text('Light'))
                : const Center(child: Text('Dark')),
          )
        ],
      )),
    );
  }
}
