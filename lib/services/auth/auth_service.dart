import 'package:eatright/services/auth/auth_provider.dart';
import 'package:eatright/services/auth/auth_user.dart';
import 'package:eatright/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String displayName,
    String? photoUrl,
  }) {
    return provider.createUser(
      email: email,
      password: password,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> init() async {
    await provider.init();
  }
}
