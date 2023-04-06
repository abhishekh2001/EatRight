import 'package:eatright/cards/replacement_card.dart';
import 'package:eatright/constants/defaults.dart';
import 'package:eatright/models/replacement.dart';
import 'package:eatright/models/user.dart';
import 'package:eatright/services/auth/auth_service.dart';
import 'package:eatright/services/data/user_service.dart';
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
  final Replacement replacement = Replacement('Nestle', 'Bru', 14, 10);
  MinUser? curMinUser;

  Future<void> _getCurMinUser() async {
    final user = AuthService.firebase().currentUser;
    final minUser = await getMinUserFromUid(uid: user?.uid);
    print('got minUser: ');
    print(minUser);
    setState(() {
      curMinUser = minUser;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurMinUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    routes.loginRoute,
                    (_) => false,
                  );
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
        children: [
          const Text('Make the choice!'),
          Text(curMinUser?.displayName ?? 'Anon'),
          CircleAvatar(
              backgroundImage:
                  NetworkImage(curMinUser?.photoUrl ?? defaultProfileUrl)),
          ReplacementCard(replacement: replacement),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          devtools.log('create new alt');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
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
