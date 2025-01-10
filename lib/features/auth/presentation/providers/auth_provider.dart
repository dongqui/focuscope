import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_apple.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;

  AuthProvider(
    this._signInWithGoogle,
    this._signInWithApple,
    this._authRepository,
  ) {
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      _status =
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> signInWithGoogle() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _signInWithGoogle(NoParams());
    result.fold(
      (failure) {
        _error = failure.toString();
        _status = AuthStatus.error;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _signInWithApple(NoParams());
    result.fold(
      (failure) {
        _error = failure.toString();
        _status = AuthStatus.error;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    final result = await _authRepository.signOut();
    result.fold(
      (failure) {
        _error = failure.toString();
        _status = AuthStatus.error;
      },
      (_) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      },
    );
    notifyListeners();
  }
}
