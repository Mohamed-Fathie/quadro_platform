import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/features/google_map/model/marker_model.dart';
import 'package:quadro_platform/features/google_map/repository/geo_conding_repository.dart';
part 'workshop_location_map_event.dart';
part 'workshop_location_map_state.dart';

class WorkshopLocationMapBloc
    extends Bloc<WorkshopLocationMapEvent, WorkshopLocationState> {
  final GeoCodingRepository _geocoding;
  GoogleMapController? _mapController;
  WorkshopLocationMapBloc()
      : _geocoding =
            GeoCodingRepository("AIzaSyBy4vQeOdM4OZlqi6Cyj6oil43a6pi-Iqg"),
        super(WorkshopLocationLoading()) {
    on<WorkshopLocationConfirmed>(
      (event, emit) async {
        if (state is! WorkshopLocationinitial) return;
        final currentstate = state as WorkshopLocationinitial;
        emit(WorkshopLocationLoading());
        final response =
            await _geocoding.reverseGeocode(currentstate.selectedLocation);
        emit(WorkshopLocationConfirmSuccess(
            coordination: currentstate.selectedLocation,
            street: response.street ?? "",
            city: response.city ?? ""));
      },
    );
    on<WorkshopMapControllerInitialized>(_onMapControllerInitialized);
    on<WorkshopLocationMapStarted>(_onWorkshopLocationMapStarted);
    on<WorkshopLocationSelected>(
      (event, emit) async {
        final currentState = state as WorkshopLocationinitial;

        // Reverse geocode the selected location

        List<MarkerModel> updatedMarkers = [
          MarkerModel(
            id: event.location.toString(),
            location: event.location,
            name: 'الموقع المحدد',
            description: 'هذا هو الموقع الذي حددته.',
          ),
        ];

        emit(currentState.copyWith(
          selectedLocation: event.location,
          markers: updatedMarkers,
        ));
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(event.location),
        );
      },
    );
    on<WorkshopLocationReset>(
      (event, emit) {
        final currentState = state;
        if (currentState is WorkshopLocationinitial) {
          // Reset to initial state with current location marker
          final currentLocation = currentState.currentLocation;
          final resetMarkers = [
            MarkerModel(
              id: currentLocation.toString(),
              location: currentLocation,
              name: 'موقعك الحالي',
              description: 'هذا هو موقعك الحالي.',
            ),
          ];

          emit(
            WorkshopLocationinitial(
              currentLocation: currentLocation,
              selectedLocation: currentLocation, // Reset to current location
              markers: resetMarkers,
            ),
          );
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(currentState.currentLocation),
          );
        }
      },
    );
  }

  void _onMapControllerInitialized(
    WorkshopMapControllerInitialized event,
    Emitter<WorkshopLocationState> emit,
  ) {
    _mapController = event.controller;
    if (state is WorkshopLocationinitial) {
      final currentState = state as WorkshopLocationinitial;
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(currentState.selectedLocation),
      );
    }
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    return super.close();
  }

// Fetch user's current location
  Future<void> _onWorkshopLocationMapStarted(
    WorkshopLocationMapStarted event,
    Emitter<WorkshopLocationState> emit,
  ) async {
    emit(WorkshopLocationLoading());
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        emit(WorkshopLocationFailure(
          errorType: WorkshopLocationErrorType.gpsDisabled,
          errorMessage: "خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز.",
        ));
        return;
      }

      // Request permission if needed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(WorkshopLocationFailure(
            errorType: WorkshopLocationErrorType.permissionDenied,
            errorMessage: "تم رفض إذن الوصول للموقع. يرجى منح الإذن للوصول.",
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(WorkshopLocationFailure(
          errorType: WorkshopLocationErrorType.permissionDenied,
          errorMessage:
              "تم رفض إذن الموقع بشكل دائم. قم بتفعيله من إعدادات التطبيق.",
        ));
        return;
      }

      // Fetch current position using new settings parameter
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // High accuracy location
          distanceFilter: 10, // Minimum distance to trigger updates
        ),
      );

      // Prepare current location and marker
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      List<MarkerModel> customMarkers = [
        MarkerModel(
          id: currentLocation.toString(),
          location: currentLocation,
          name: 'موقعك الحالي',
          description: 'هذا هو موقعك الحالي.',
        ),
      ];

      emit(WorkshopLocationinitial(
        currentLocation: currentLocation,
        selectedLocation: currentLocation,
        markers: customMarkers,
      ));
    } catch (e) {
      emit(WorkshopLocationFailure(
        errorType: WorkshopLocationErrorType.unknown,
        errorMessage: "حدث خطأ غير متوقع: $e",
      ));
    }
  }
}
