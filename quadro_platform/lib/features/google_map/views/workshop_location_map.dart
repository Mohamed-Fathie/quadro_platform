import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/features/google_map/bloc/workshop_location_map_bloc.dart';

import 'widgets/confirm_button.dart';
import 'widgets/map_appBar.dart';
import 'widgets/map_view.dart';
import 'widgets/reset_location.dart';

class WorkshopLocationMapPage extends StatelessWidget {
  final LatLng? loc;
  const WorkshopLocationMapPage({super.key, this.loc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkshopLocationMapBloc(location: loc)
        ..add(WorkshopLocationMapStarted()),
      child: const WorkshopLocationMap(),
    );
  }
}

class WorkshopLocationMap extends StatelessWidget {
  const WorkshopLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          MapView(),
          MapAppBar(),
          ConfirmButton(),
          ResetLocationButton(),
        ],
      ),
    );
  }
}
