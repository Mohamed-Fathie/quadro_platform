import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_profile/cubit/workshop_profile_cubit.dart';
import 'package:sizer/sizer.dart';

import 'popup_menu_button.dart';

class WorkshopImageAppbar extends StatelessWidget {
  const WorkshopImageAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final imageLink = context
        .select((WorkshopProfileCubit bloc) => bloc.state.workshop?.imagePath);
    return SliverAppBar(
      leading: const WorkshopPopupMenuButton(),
      expandedHeight: 35.h,
      flexibleSpace: FlexibleSpaceBar(
          background: Image.network(
              fit: BoxFit.cover,
              imageLink ??
                  "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b")),
    );
  }
}
