import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import 'delete_confirmation.dart';

Widget buildDeleteFab(
    BuildContext context, MaintenanceRequestDomainModel request) {
  return FloatingActionButton.extended(
    backgroundColor: Qcolors.primarycolor.withOpacity(0.9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    label: Text('حذف الطلب',
        style: TextStyle(color: Colors.white, fontSize: 18.sp)),
    onPressed: () => showDeleteConfirmation(context, request),
  );
}
