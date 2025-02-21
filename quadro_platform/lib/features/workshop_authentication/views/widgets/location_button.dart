import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/routes/navigation_service.dart';
import '../../../../shared/routes/routes_constants.dart';
import '../../../../shared/utils/constans/colors.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../../google_map/model/selected_location.dart';
import '../../cubit/authbloc_cubit.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final location =
        context.select((WorkshopAuthbloc bloc) => bloc.state.location);
    final street = location?.street == "Unknown street" ? "" : location?.street;
    return location == null
        ? CustomElevatedButton(
            buttonColor: Qcolors.buttonbackground,
            buttonTitle: "حدد الموقع",
            onPressed: () async {
              final location = await NavigationService()
                  .routeTo(RoutesConstants.workshopLocationMap);
              log(location.toString());
              if (location != null) {
                context
                    .read<WorkshopAuthbloc>()
                    .onSelectedLocation(location as SelectedLocation);
              }
            },
            icon: Icons.location_on,
            iconColor: Qcolors.primarycolor,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5.w),
            child: ColoredBox(
              color: Qcolors.buttonbackground,
              child: SizedBox(
                height: 8.h,
                width: 85.w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Qcolors.primarycolor,
                      ),
                      Text(
                        "${location.city ?? ""} , $street  ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Qcolors.primarycolor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
