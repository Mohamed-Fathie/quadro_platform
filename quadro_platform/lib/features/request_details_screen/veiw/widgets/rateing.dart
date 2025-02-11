import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../cubit/details_cubit.dart';

Widget buildRatingBottomBar(
    BuildContext context, MaintenanceRequestDomainModel request) {
  return Container(
    height: 120,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Qcolors.getPrimeryColor(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "قيم الخدمة",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, _) => const Icon(
            Icons.star_rounded,
            color: Qcolors.warning,
          ),
          onRatingUpdate: (rating) {
            _showRatingConfirmation(context, request, rating);
          },
        ),
      ],
    ),
  );
}

void _showRatingConfirmation(BuildContext context,
    MaintenanceRequestDomainModel request, double rating) {
  final cubit = context.read<DetailsCubit>();
  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.star_rounded, size: 40, color: Qcolors.warning),
        title: Text('تأكيد التقييم',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'هل أنت متأكد من تقييم الخدمة ب $rating نجوم؟',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            child:
                const Text('إلغاء', style: TextStyle(color: Qcolors.secondary)),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.star_rounded, size: 20),
            label: const Text('تأكيد التقييم'),
            style: FilledButton.styleFrom(
              backgroundColor: Qcolors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              cubit.submitRating(
                  userId: request.user.id,
                  workshopId: request.workshop.ownerId,
                  requestId: request.id,
                  offerId: request.offer!.id!,
                  rating: rating,
                  comment: "خدمة ممتازة");

              NavigationService().goBack(result: true);
            },
          ),
        ],
      ),
    ),
  );
}
