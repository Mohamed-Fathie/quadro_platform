import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../cubit/details_cubit.dart';

void showDeleteConfirmation(
    BuildContext context, MaintenanceRequestDomainModel request) {
  // Capture the cubit from the correct context.
  final detailsCubit = context.read<DetailsCubit>();

  showDialog(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.delete_forever_rounded,
            size: 40, color: Qcolors.warning),
        title:
            Text('حذف الطلب', style: Theme.of(context).textTheme.headlineLarge),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف هذا الطلب بشكل دائم؟',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء',
                style: TextStyle(color: Qcolors.primarycolor)),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.delete_rounded, size: 20),
            label: const Text('حذف الآن'),
            style: FilledButton.styleFrom(
              backgroundColor: Qcolors.primarycolor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Use the captured cubit.
              detailsCubit.deleteRequest(request.id);
              Navigator.pop(dialogContext); // close the dialog
              Navigator.pop(context); // then close the details screen if needed
            },
          ),
        ],
      ),
    ),
  );
}
