part of 'main_screenbloc_bloc.dart';

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

@immutable
class MainScreenOffersFetched extends MainScreenEvent {
  MainScreenOffersFetched();
}
