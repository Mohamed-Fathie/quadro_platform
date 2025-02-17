import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/user_role.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/registeration_cubit.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String description;
  final String? path;

  const RoleCard({
    super.key,
    required this.title,
    this.icon,
    this.path,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterationCubit, RegisterationState>(
      builder: (context, state) {
        final isSelected =
            state is RoleSelected && state.selectedRole == title.toUserRole();
        return InkWell(
          onTap: () => context
              .read<RegisterationCubit>()
              .selectRole(title.toUserRole()!),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 20.h,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[50] : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Qcolors.secondary : Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                icon != null
                    ? Icon(icon, size: 8.h, color: Qcolors.secondary)
                    : Image.asset(
                        width: 8.h, height: 8.h, fit: BoxFit.cover, path!),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Qcolors.secondary,
                              )),
                      Text(description,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              )),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Qcolors.secondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
