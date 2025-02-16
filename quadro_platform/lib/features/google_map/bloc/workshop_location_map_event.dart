part of 'workshop_location_map_bloc.dart';

@immutable
sealed class WorkshopLocationMapEvent {}

final class WorkshopLocationMapStarted extends WorkshopLocationMapEvent {}

class WorkshopMapControllerInitialized extends WorkshopLocationMapEvent {
  final GoogleMapController controller;

  WorkshopMapControllerInitialized({required this.controller});
}

final class WorkshopLocationSelected extends WorkshopLocationMapEvent {
  final LatLng location;

  WorkshopLocationSelected({required this.location});
}

final class WorkshopLocationConfirmed extends WorkshopLocationMapEvent {}

final class WorkshopLocationReset extends WorkshopLocationMapEvent {}
