import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../bloc/workshop_location_map_bloc.dart';

class ResetLocationButton extends StatelessWidget {
  const ResetLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25.w, // Position above confirm button
      right: 5.w,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Qcolors.getCurrentColor(context),
        onPressed: () {
          context.read<WorkshopLocationMapBloc>().add(WorkshopLocationReset());
        },
        child: const Icon(
          Icons.my_location,
          color: Qcolors.primarycolor,
        ),
      ),
    );
  }
}
