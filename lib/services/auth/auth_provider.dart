import 'package:eatright/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> init();
}
