import 'package:flutter/material.dart';

import '../../../../shared/utils/constans/colors.dart';
import '../../../workshop_main_screen/models/maintenance_request_data_model.dart';
import 'confirmation_dialog.dart';

Widget buildOfferResponseBar(
    BuildContext context, MaintenanceRequestDomainModel request) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: Qcolors.getPrimeryColor(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildResponseButton(
          context: context,
          label: 'رفض العرض',
          icon: Icons.close_rounded,
          color: Qcolors.warning,
          onPressed: () => showResponseConfirmation(context, request, false),
        ),
        _buildResponseButton(
          context: context,
          label: 'قبول العرض',
          icon: Icons.check_rounded,
          color: Qcolors.success,
          onPressed: () => showResponseConfirmation(context, request, true),
        ),
      ],
    ),
  );
}

Widget _buildResponseButton({
  required BuildContext context,
  required String label,
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    icon: Icon(icon, size: 24, color: Colors.white),
    label:
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.white30, width: 1),
      ),
    ),
    onPressed: onPressed,
  );
}
