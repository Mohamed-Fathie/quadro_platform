import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../cubit/workshop_profile_cubit.dart';
import 'review_header.dart';
import 'review_list.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkshopProfileCubit, WorkshopProfileState,
        WorkshopProfileStatus>(
      selector: (state) => state.status,
      builder: (context, state) {
        if (state == WorkshopProfileStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state == WorkshopProfileStatus.failure) {
          return CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.error, color: Colors.red),
          );
        }

        return const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewsHeader(),
              SizedBox(
                height: 25,
              ),
              Divider(color: Qcolors.primarycolor, thickness: 2),
              ReviewList(),
            ],
          ),
        );
      },
    );
  }
}
