import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart' as routes;

enum MenuAction { logout }

class EatRight extends StatefulWidget {
  const EatRight({super.key});

  @override
  State<EatRight> createState() => _EatRightState();
}

class _EatRightState extends State<EatRight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Eat-Right'),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              devtools.log('$value');
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log('should logout: $shouldLogout');

                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        routes.loginRoute, (_) => false);
                  }
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out'))
              ];
            })
          ],
        ),
        body: Column(
          children: [const Text('Make the choice!')],
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Agree')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
