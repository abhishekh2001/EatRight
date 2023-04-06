class LoginAuthException implements Exception {}

class RegisterAuthException implements Exception {}

class GenericAuthException implements Exception {
  final String code;

  GenericAuthException(this.code);
}

class UserNotLoggedInAuthException implements Exception {}
