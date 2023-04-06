import 'package:eatright/services/auth/auth_user.dart';
import 'package:eatright/services/auth/auth_provider.dart';
import 'package:eatright/services/auth/auth_exceptions.dart';
import 'package:eatright/services/data/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final userC =
          await FA.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userC.user != null) {
        createUserDetails(
          uid: userC.user?.uid ?? '-',
          displayName: displayName,
          photoUrl: photoUrl,
        );
      }

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FA.FirebaseAuthException catch (err) {
      throw GenericAuthException(err.code);
    } catch (err) {
      throw GenericAuthException('other-error');
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FA.FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FA.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FA.FirebaseAuthException catch (err) {
      throw GenericAuthException(err.code);
    } catch (err) {
      throw GenericAuthException('other-error');
    }
  }

  @override
  Future<void> logOut() async {
    final user = FA.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FA.FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
