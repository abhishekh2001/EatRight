import 'dart:io';

import 'package:eatright/constants/routes.dart' as routes;
import 'package:eatright/services/auth/auth_exceptions.dart';
import 'package:eatright/services/data/image_service.dart';
import 'package:eatright/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import '../services/auth/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _displayName;

  late File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _displayName = TextEditingController();
    _imageFile = null;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _displayName.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    devtools.log('picking image... 2');
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
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
              decoration: const InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Enter password'),
            ),
            const SizedBox(height: 50),
            CircleAvatar(
                radius: 56,
                backgroundColor: Color(0xff476cfb),
                child: ClipOval(
                  child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: _imageFile != null
                          ? Image.file(_imageFile as File, fit: BoxFit.fill)
                          : Image.network(
                              'https://i.ytimg.com/vi/Z5CxyeIYSJw/hqdefault.jpg',
                              fit: BoxFit.fill,
                            )),
                )),
            ElevatedButton(
                onPressed: pickImage, child: const Text('Pick Image')),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final dname = _displayName.text;

                try {
                  String? photoUrl = null;
                  if (_imageFile != null) {
                    devtools.log('uploading image ${_imageFile?.path ?? '<>'}');
                    photoUrl = await uploadImageFileToStorage(_imageFile!);
                  }
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                    displayName: dname,
                    photoUrl: photoUrl,
                  );
                  final user = AuthService.firebase().currentUser;

                  if (user == null) {
                    devtools.log('user is null');
                  } else {
                    devtools.log(user.displayName);
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    routes.loginRoute,
                    (route) => false,
                  );
                } on GenericAuthException catch (err) {
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
