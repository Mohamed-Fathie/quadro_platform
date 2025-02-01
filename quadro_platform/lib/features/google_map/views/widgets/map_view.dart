import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/gradient_circular_progress.dart';
import '../../bloc/workshop_location_map_bloc.dart';
import '../../model/marker_model.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkshopLocationMapBloc, WorkshopLocationState>(
      listener: (context, state) {
        if (state is WorkshopLocationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.exception.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is WorkshopLocationLoading) {
          return const Center(child: GradientCircularProgress());
        }
        if (state is WorkshopLocationinitial) {
          return _buildMap(state, context);
        }
        return const Center(child: GradientCircularProgress());
      },
    );
  }

  Widget _buildMap(WorkshopLocationinitial state, BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        context
            .read<WorkshopLocationMapBloc>()
            .add(WorkshopMapControllerInitialized(controller: controller));
      },
      myLocationButtonEnabled: false, // Custom reset button
      myLocationEnabled: true,
      compassEnabled: true,
      style: Qcolors.getMapTheme(context),
      initialCameraPosition: CameraPosition(
        zoom: 12.0,
        target: state.currentLocation,
      ),
      markers: _getMarkers(state.markers),
      onTap: (location) => _handleMapTap(context, location),
    );
  }

  Set<Marker> _getMarkers(List<MarkerModel> markers) {
    return markers.map((marker) {
      return Marker(
        markerId: MarkerId(marker.id ?? "marker-${UniqueKey()}"),
        position: marker.location,
        infoWindow: InfoWindow(
          title: marker.name,
          snippet: marker.description,
        ),
      );
    }).toSet();
  }

  void _handleMapTap(BuildContext context, LatLng location) {
    context
        .read<WorkshopLocationMapBloc>()
        .add(WorkshopLocationSelected(location: location));
  }
}
