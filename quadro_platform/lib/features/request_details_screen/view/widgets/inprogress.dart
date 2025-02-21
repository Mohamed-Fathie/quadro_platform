import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import '../../cubit/details_cubit.dart';

Widget buildWorkshopProgressBar(
    BuildContext context, MaintenanceRequestDomainModel request) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: Qcolors.getCurrentColor(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
      ],
    ),
    child: Center(
      child: _buildProgressButton(context, request),
    ),
  );
}

Widget _buildProgressButton(
    BuildContext context, MaintenanceRequestDomainModel request) {
  return ElevatedButton.icon(
    icon: const Icon(Icons.build_rounded, size: 24, color: Colors.white),
    label: const Text('بدء العمل على الطلب',
        style: TextStyle(fontSize: 16, color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Qcolors.success,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.white30, width: 1),
      ),
    ),
    onPressed: () => _showProgressConfirmation(context, request),
  );
}

void _showProgressConfirmation(
    BuildContext context, MaintenanceRequestDomainModel request) {
  final cubit = context.read<DetailsCubit>();
  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(Icons.timer_rounded, size: 40, color: Qcolors.info),
        title:
            Text('بدء العمل', style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'هل أنت متأكد من بدء العمل على هذا الطلب؟ سيتم تغيير حالة الطلب إلى "قيد التنفيذ"',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            child:
                const Text('إلغاء', style: TextStyle(color: Qcolors.secondary)),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.timer_rounded, size: 20),
            label: const Text('تأكيد البدء'),
            style: FilledButton.styleFrom(
              backgroundColor: Qcolors.info,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              cubit.markOfferInProgress(
                  requestId: request.id, offerId: request.offer!.id!);
              // cubit.initionlization(
              //     requestType: RequestType.workshop_id, request: request);
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    ),
  );
}
