import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_profile/cubit/workshop_profile_cubit.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/enum/workshop_profile_menu.dart';
import '../../../../shared/utils/constans/colors.dart';

class WorkshopPopupMenuButton extends StatelessWidget {
  const WorkshopPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WorkshopProfileMenu>(
      onSelected: (value) =>
          context.read<WorkshopProfileCubit>().onSelectedMenu(value),
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Round the edges
        child: SizedBox(
          width: 4.h, // Set width of the box
          height: 4.h, // Set height of the box
          child: ColoredBox(
            color: Qcolors.getCurrentColor(context), // Background color
            child: const Icon(
              Icons.more_vert,
              color: Qcolors.primarycolor, // Icon color
              size: 24, // Icon size
            ),
          ),
        ),
      ),
      color: Qcolors.getCurrentColor(context), // Background color for the menu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners for the menu
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: WorkshopProfileMenu.edit,
          child: ListTile(
            leading: const Icon(
              Icons.edit,
              color: Qcolors.primarycolor, // Icon color for "Edit Profile"
              size: 20, // Icon size
            ),
            title: Text('تعديل الملف الشخصي',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
        PopupMenuItem(
          value: WorkshopProfileMenu.logout,
          child: ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red, // Icon color for "Log Out"
              size: 20, // Icon size
            ),
            title: Text('تسجيل الخروج',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
      ],
    );
  }
}
