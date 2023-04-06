import 'package:eatright/views/eatright.dart';
import 'package:eatright/views/login_view.dart';
import 'package:eatright/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'constants/routes.dart' as routes;
import 'firebase_options.dart';
// import 'package:eatright/views/register_view.dart'

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Eat Right',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        routes.loginRoute: (context) => const LoginView(),
        routes.registerRoute: (context) => const RegisterView(),
        routes.eatrightRoute: (context) => const EatRight(),
      },
    ),
  );
}

enum MenuAction { logout }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                return const EatRight();
              } else {
                return const LoginView();
              }
              print(user);
            default:
              return const CircularProgressIndicator();
          }
          ;
        });
  }
}
