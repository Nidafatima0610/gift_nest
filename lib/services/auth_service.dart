import '../models/user_model.dart';

/// Contract for Authentication service.
/// Ready to connect to Firebase Authentication or API backend.
abstract class AuthService {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}

/// Initial implementation stub for [AuthService].
/// Firebase Auth integration will be wired here.
class AuthServiceImpl implements AuthService {
  @override
  Stream<UserModel?> get authStateChanges => const Stream.empty();

  @override
  UserModel? get currentUser => null;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Firebase Auth signInWithEmailAndPassword will be connected here
    throw UnimplementedError('Auth service will be connected to Firebase');
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Firebase Auth createUserWithEmailAndPassword will be connected here
    throw UnimplementedError('Auth service will be connected to Firebase');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Firebase Auth sendPasswordResetEmail will be connected here
    throw UnimplementedError('Auth service will be connected to Firebase');
  }

  @override
  Future<void> signOut() async {
    // Firebase Auth signOut will be connected here
  }
}
