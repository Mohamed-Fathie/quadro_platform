part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class AppInitialization extends LoginEvent {}

final class AppLogoutPressed extends LoginEvent {}
