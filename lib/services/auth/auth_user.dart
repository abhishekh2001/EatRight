import 'package:firebase_auth/firebase_auth.dart' as FA show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String uid;
  final bool isEmailVerified;
  final String displayName;
  final String photoUrl;

  const AuthUser(
      this.uid, this.isEmailVerified, this.displayName, this.photoUrl);

  factory AuthUser.fromFirebase(FA.User user) => AuthUser(
      user.uid,
      user.emailVerified,
      user.displayName ?? 'Anon',
      user.photoURL ?? 'https://i.ytimg.com/vi/Z5CxyeIYSJw/hqdefault.jpg');
}
