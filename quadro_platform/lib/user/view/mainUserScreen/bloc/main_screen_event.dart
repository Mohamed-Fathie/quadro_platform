part of 'main_screen_bloc.dart';

@immutable
sealed class MainScreenEvent {}

@immutable
class MainScreenStarted extends MainScreenEvent {
  MainScreenStarted();
}

@immutable
class MainScreenRequestFetched extends MainScreenEvent {
  MainScreenRequestFetched();
}
