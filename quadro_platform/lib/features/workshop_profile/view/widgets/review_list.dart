import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_profile/model/Review_Domain.dart';
import 'package:sizer/sizer.dart';

import '../../cubit/workshop_profile_cubit.dart';
import 'review_item.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkshopProfileCubit, WorkshopProfileState, List?>(
      selector: (state) => state.reviewslist,
      builder: (context, reviewslist) {
        if (reviewslist == null || reviewslist.isEmpty) {
          return SizedBox(
              height: 30.h,
              child: Center(
                  child: Text(
                "لا يوجد تقييمات لهده الورشة",
                style: Theme.of(context).textTheme.headlineMedium,
              )));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviewslist.length,
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey.shade400, thickness: 0.5.w),
          itemBuilder: (context, index) {
            final review = reviewslist[index] as ReviewDomainModel;
            return ReviewItem(review: review);
          },
        );
      },
    );
  }
}
