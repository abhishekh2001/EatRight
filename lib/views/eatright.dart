import 'package:eatright/cards/replacement_card.dart';
import 'package:eatright/constants/defaults.dart';
import 'package:eatright/models/comment.dart';
import 'package:eatright/models/replacement.dart';
import 'package:eatright/models/user.dart';
import 'package:eatright/services/auth/auth_service.dart';
import 'package:eatright/services/data/replacement_service.dart';
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
  MinUser? curMinUser;
  List<Replacement>? replacements;

  Future<void> _getCurMinUser() async {
    final user = AuthService.firebase().currentUser;
    final minUser = await getMinUserFromUid(user?.uid);
    await minUser.fillCommits();
    devtools.log('got minUser: ${minUser.displayName}');

    var reps = await getAllReplacementsRec();

    setState(() {
      curMinUser = minUser;
      replacements = reps;
    });
  }

  Future<void> onEachStart() async {
    await _getCurMinUser();
  }

  Future<void> _handleUserCommit(String repId) async {
    if (curMinUser != null) {
      await createCommitOnRep(curMinUser?.uid ?? '', repId);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurMinUser();
  }

  void _onTapCommit(List<MinUser> commits) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .2,
          minChildSize: .1,
          maxChildSize: .6,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              height: null,
              color: Colors.lightGreen[100],
              child: ListView.builder(
                controller: scrollController,
                itemCount: commits.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            commits[index].photoUrl,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          commits[index].displayName,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _onTap(List<Comment> comments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .2,
          minChildSize: .1,
          maxChildSize: .6,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              height: null,
              color: Colors.lightGreen[100],
              child: ListView.builder(
                controller: scrollController,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(comments[index].content),
                    subtitle: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            comments[index].user.photoUrl,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          comments[index].user.displayName,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Eat-Right'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routes.eatrightRoute);
            },
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: replacements == null
                  ? const Text("loading...")
                  : Column(children: [
                      ...replacements
                              ?.map((rep) => ReplacementCard(
                                    replacement: rep,
                                    onTap: _onTap,
                                    onTapCommit: _onTapCommit,
                                    enableCommit: (curMinUser?.commits
                                            ?.contains(rep.id) ==
                                        false),
                                    handleUserCommit: _handleUserCommit,
                                  ))
                              .toList() ??
                          []
                    ]),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          devtools.log('create new alt');
          Navigator.pushNamed(
            context,
            routes.newReplacementRoute,
          );
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
