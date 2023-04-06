import 'package:firebase_auth/firebase_auth.dart' as FA show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String displayName;
  // final String photoUrl;

  const AuthUser(this.isEmailVerified, this.displayName);
  factory AuthUser.fromFirebase(FA.User user) =>
      AuthUser(user.emailVerified, user.displayName ?? 'Anon');
}
