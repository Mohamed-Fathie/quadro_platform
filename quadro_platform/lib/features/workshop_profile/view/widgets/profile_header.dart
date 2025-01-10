import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_profile/cubit/workshop_profile_cubit.dart';

import '../../../../shared/utils/constans/colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final workshop = context.select(
      (WorkshopProfileCubit value) => value.state.workshop,
    );
    final workshopReview = context.select(
      (WorkshopProfileCubit value) => value.state.reviewInfo,
    );
    return FlexibleSpaceBar(
      background: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(bottom: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Qcolors.primarycolor.withAlpha(
                  (0.8 * 255).toInt()), // Convert opacity to alpha value
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Name
                Expanded(
                  child: Text(
                    workshop!.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 24),
                    Text(
                      " ${workshopReview!["averageRating"]}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
