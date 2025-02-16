import 'package:flutter/material.dart';
import 'package:quadro_platform/features/workshop_profile/model/Review_Domain.dart';
import 'package:quadro_platform/shared/utils/extension/date_formating.dart';
import 'package:quadro_platform/shared/widgets/rating_stars.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import 'workshop_reply.dart';

class ReviewItem extends StatelessWidget {
  final ReviewDomainModel review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Information Row
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  review.user.pictureUrl ??
                      "https://firebasestorage.googleapis.com/v0/b/quadro-204be.firebasestorage.app/o/Profile_Images%2Fdhdhdgg%40gmail.com42435c00-c43b-11ef-b85b-879b0d7d6b91?alt=media&token=ee320211-7794-4481-b66a-6d5f048f035b",
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      review.dateCreated.formatInArabic(withouthours: true),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              Expanded(
                child: Row(
                  spacing: 3.w,
                  children: [
                    RatingWidget(rating: review.rating),
                    Text(
                      review.rating.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // User Comment
          ReadMoreText(
            review.reviewComment!,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: "...عرض المزيد",
            trimExpandedText: "عرض أقل",
            colorClickableText: Theme.of(context).primaryColor,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 2.h),

          // Workshop Owner Reply Section
          WorkshopOwnerReply(review: review),
        ],
      ),
    );
  }
}
