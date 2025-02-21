import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_profile_cubit.dart';

class ReviewsHeader extends StatelessWidget {
  const ReviewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkshopProfileCubit, WorkshopProfileState,
        Map<String, dynamic>?>(
      selector: (state) => state.reviewInfo,
      builder: (context, reviewInfo) {
        final reviewCount = reviewInfo?["reviewCount"] ?? 0;

        return RichText(
          text: TextSpan(
            text: "عدد التقييمات",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Qcolors.primarycolor,
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: " ($reviewCount) ",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.apply(color: Qcolors.primarycolor),
              ),
            ],
          ),
        );
      },
    );
  }
}
