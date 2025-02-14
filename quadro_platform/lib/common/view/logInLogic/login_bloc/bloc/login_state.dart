part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class Onboarding extends LoginState {
  @override
  List<Object?> get props => [];
}

final class Authenticated extends LoginState {
  final UserRole userRole;

  Authenticated({required this.userRole});
  @override
  List<Object?> get props => [userRole];
}

final class AuthError extends LoginState {
  final String error;

  AuthError({required this.error});
  @override
  List<Object?> get props => [error];
}

final class Unauthenticated extends LoginState {
  @override
  List<Object?> get props => [];
}
