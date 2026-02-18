import 'dart:async';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

abstract class AuthRepository {
  Stream<AuthStatus> get status;
  Future<void> logIn({required String email, required String password});
  Future<void> logOut();
  Future<void> signUp({required String email, required String password});
}
