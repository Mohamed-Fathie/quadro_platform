part of 'workshop_location_map_bloc.dart';

@immutable
sealed class WorkshopLocationState extends Equatable {}

final class WorkshopLocationLoading extends WorkshopLocationState {
  @override
  List<Object?> get props => [];
}

final class WorkshopLocationinitial extends WorkshopLocationState {
  final LatLng currentLocation;
  final LatLng selectedLocation;
  final List<MarkerModel> markers;

  WorkshopLocationinitial({
    required this.currentLocation,
    required this.selectedLocation,
    required this.markers,
  });

  WorkshopLocationinitial copyWith({
    LatLng? currentLocation,
    LatLng? selectedLocation,
    List<MarkerModel>? markers,
  }) {
    return WorkshopLocationinitial(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [
        currentLocation,
        selectedLocation,
        markers,
      ];
}

final class WorkshopLocationFailure extends WorkshopLocationState {
  final WorkshopLocationException exception;

  WorkshopLocationFailure({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

final class WorkshopLocationConfirmSuccess extends WorkshopLocationState {
  final LatLng coordination;
  final String street;
  final String city;

  WorkshopLocationConfirmSuccess(
      {required this.coordination, required this.street, required this.city});
  @override
  List<Object?> get props => [street, city, coordination];
}
