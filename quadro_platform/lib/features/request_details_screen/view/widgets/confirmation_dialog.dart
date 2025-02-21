import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/routes/navigation_service.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../cubit/details_cubit.dart';

void showResponseConfirmation(BuildContext context,
    MaintenanceRequestDomainModel request, bool isAccept) {
  final cubit = context.read<DetailsCubit>();

  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: Icon(
          isAccept ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
          size: 40,
          color: isAccept ? Qcolors.success : Qcolors.warning,
        ),
        title: Text(isAccept ? 'قبول العرض' : 'رفض العرض',
            style: Theme.of(context).textTheme.headlineLarge),
        content: Text(
          isAccept
              ? 'هل أنت متأكد من قبول هذا العرض؟ '
              : 'هل أنت متأكد من رفض هذا العرض؟ لا يمكن التراجع عن هذا الإجراء',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TextButton(
            child:
                const Text('إلغاء', style: TextStyle(color: Qcolors.secondary)),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton.icon(
            icon: Icon(isAccept ? Icons.check_rounded : Icons.close_rounded,
                size: 20),
            label: Text(isAccept ? 'تأكيد القبول' : 'تأكيد الرفض'),
            style: FilledButton.styleFrom(
              backgroundColor: isAccept ? Qcolors.success : Qcolors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Call cubit method

              isAccept
                  ? cubit.acceptOffer(request.id, request.offer?.id ?? "")
                  : cubit.rejectOffer(request.id, request.offer?.id ?? "");

              NavigationService().goBack();

              // WorkshopScreens().controller.jumpToTab(0);
            },
          ),
        ],
      ),
    ),
  );
}
