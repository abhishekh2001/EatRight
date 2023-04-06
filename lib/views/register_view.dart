import 'package:eatright/constants/routes.dart' as routes;
import 'package:eatright/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _displayName;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _displayName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Column(
          children: [
            TextField(
                controller: _displayName,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Enter name')),
            TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter email')),
            TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Enter password')),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final dname = _displayName.text;

                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (userCredential.user == null) {
                    devtools.log('no user found', level: 1);
                  }
                  await userCredential.user?.updateDisplayName(dname);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    routes.loginRoute,
                    (route) => false,
                  );
                  devtools.log('$userCredential');
                } on FirebaseAuthException catch (err) {
                  await showErrorDialog(context, err.code);
                  devtools.log('encountered error, $err');
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      routes.loginRoute, (route) => false);
                },
                child: const Text('Have an account? Login'))
          ],
        ));
  }
}
