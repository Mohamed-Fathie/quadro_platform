import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_profile/cubit/workshop_profile_cubit.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import 'popup_menu_button.dart';

class WorkshopImageAppbar extends StatelessWidget {
  final RequestType? requestType;
  const WorkshopImageAppbar({super.key, this.requestType});

  @override
  Widget build(BuildContext context) {
    final imageLink = context
        .select((WorkshopProfileCubit bloc) => bloc.state.workshop?.imagePath);
    return SliverAppBar(
      leading: requestType != null
          ? IconButton(
              onPressed: () => NavigationService().goBack(),
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Round the edges
                child: SizedBox(
                  width: 4.h, // Set width of the box
                  height: 4.h, // Set height of the box
                  child: ColoredBox(
                    color: Qcolors.getCurrentColor(context), // Background color
                    child: const Icon(
                      Icons.arrow_back,
                      color: Qcolors.primarycolor, // Icon color
                      size: 24, // Icon size
                    ),
                  ),
                ),
              ))
          : const WorkshopPopupMenuButton(),
      expandedHeight: 35.h,
      flexibleSpace: FlexibleSpaceBar(
          background: Image.network(
              fit: BoxFit.cover,
              imageLink ??
                  "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b")),
    );
  }
}
