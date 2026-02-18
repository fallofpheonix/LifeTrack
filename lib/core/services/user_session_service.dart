import 'dart:async';
import 'package:lifetrack/core/data/repository/auth_repository.dart';
import 'package:lifetrack/core/data/local/local_token_store.dart';

class UserSessionService {
  final AuthRepository _authRepository;
  final LocalTokenStore _tokenStore;
  
  UserSessionService({
    required AuthRepository authRepository,
    required LocalTokenStore tokenStore,
  }) : _authRepository = authRepository,
       _tokenStore = tokenStore;

  Stream<AuthStatus> get authStatus => _authRepository.status;

  Future<void> init() async {
    // Check for existing token
    final String? token = await _tokenStore.getToken();
    if (token != null) {
      // Validate token or refresh session
      // For now, we assume if token exists, we are authenticated (Mock logic)
    }
  }

  Future<void> login(String email, String password) async {
    await _authRepository.logIn(email: email, password: password);
    // Token saving happens inside specific AuthRepository impl
  }

  Future<void> logout() async {
    await _authRepository.logOut();
    await _tokenStore.deleteToken();
  }
}
