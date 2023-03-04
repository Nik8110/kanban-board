part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SigninWithEmailPasswordEvent extends AuthEvent {
  @override
  List<Object?> get props => [email, password, isLogin];
  final String? email;
  final String? password;
  final bool? isLogin;

  final BuildContext? context;
  const SigninWithEmailPasswordEvent.name({
    this.context,
    this.email,
    this.password,
    this.isLogin = false,
  });
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({this.isLogin = false, this.context});
  final bool? isLogin;
  final BuildContext? context;

  @override
  List<Object?> get props => [context, isLogin];
}
