import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../core/data/repository/auth_repository.dart';
import '../../core/data/local/local_token_store.dart';

class MockAuthRepository implements AuthRepository {
  final LocalTokenStore _tokenStore;
  final StreamController<AuthStatus> _controller = StreamController<AuthStatus>();

  MockAuthRepository({required LocalTokenStore tokenStore}) : _tokenStore = tokenStore;

  @override
  Stream<AuthStatus> get status async* {
    yield AuthStatus.unknown;
    yield* _controller.stream;
  }

  @override
  Future<void> logIn({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock successful login
    final String mockToken = const Uuid().v4();
    await _tokenStore.saveToken(mockToken);
    
    _controller.add(AuthStatus.authenticated);
  }

  @override
  Future<void> logOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _tokenStore.deleteToken();
    _controller.add(AuthStatus.unauthenticated);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock successful signup
    final String mockToken = const Uuid().v4();
    await _tokenStore.saveToken(mockToken);
    
    _controller.add(AuthStatus.authenticated);
  }

  void dispose() => _controller.close();
}
