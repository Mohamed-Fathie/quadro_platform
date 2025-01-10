import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_profile/model/Review_Domain.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import 'workshop_owner_comment_form.dart';

class WorkshopOwnerReply extends StatelessWidget {
  final ReviewDomainModel review;

  const WorkshopOwnerReply({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    if (review.workshopComment != null) {
      return Container(
        decoration: BoxDecoration(
          color: Qcolors.getCurrentColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "رد مالك الورشة",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            ReadMoreText(
              review.workshopComment ?? '',
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: "...عرض المزيد",
              trimExpandedText: "عرض أقل",
              colorClickableText: Qcolors.primarycolor,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
      );
    } else {
      return WorkshopOwnerCommentForm(reviewId: review.id);
    }
  }
}
