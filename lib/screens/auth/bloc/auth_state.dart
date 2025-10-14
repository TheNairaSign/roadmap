
part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserModel user) 
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() 
      : this._(status: AuthStatus.unauthenticated);
      
  const AuthState.loading() 
      : this._(status: AuthStatus.loading);

  const AuthState.failure(String errorMessage) 
      : this._(status: AuthStatus.failure, errorMessage: errorMessage);

  @override
  List<Object?> get props => [status, user, errorMessage];
}
