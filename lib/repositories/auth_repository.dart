
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadmap/models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService}) : _authService = authService ?? AuthService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<UserCredential?> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password, String name) {
    return _authService.signUpWithEmailAndPassword(email, password, name);
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Future<UserModel?> getUser(String uid) async {
    return _authService.getUser(uid);
  }
}
