part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  @override
  List<Object> get props => [];
  final String? errorMsg;
  const AuthError({this.errorMsg});
}

class AuthLoaded extends AuthState {
  @override
  List<Object> get props => [];
  final int? dateModel;
  const AuthLoaded({this.dateModel});
}
