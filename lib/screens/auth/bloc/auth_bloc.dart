
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthEmailSignUpRequested>(_onAuthEmailSignUpRequested);
    on<AuthEmailSignInRequested>(_onAuthEmailSignInRequested);

    _userSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  void _onAuthGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  void _onAuthEmailSignUpRequested(AuthEmailSignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signUpWithEmailAndPassword(event.email, event.password, event.name);
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  void _onAuthEmailSignInRequested(AuthEmailSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signInWithEmailAndPassword(event.email, event.password);
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
