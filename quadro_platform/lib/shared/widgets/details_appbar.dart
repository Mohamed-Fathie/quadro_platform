// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

class DetailsAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool? isdeltable;
  final bool? isResponsable;
  final String title;
  final RequestType requestType;
  const DetailsAppbar(
      {super.key,
      required this.title,
      required this.requestType,
      this.isdeltable,
      this.isResponsable});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: requestType == RequestType.vehicle_owner_id
          ? Qcolors.getPrimeryColor(context)
          : Qcolors.getCurrentColor(context),
      centerTitle: true,
      title: Text(title),
      flexibleSpace: isdeltable != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Qcolors.secondary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            )
          : isResponsable != null
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Qcolors.warning.withOpacity(0.1),
                        Qcolors.success.withOpacity(0.1),
                      ],
                    ),
                  ),
                )
              : null,
    );
  }
}
