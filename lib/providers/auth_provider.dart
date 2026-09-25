import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Manages user authentication state using Provider.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthServiceImpl();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
