import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';

import '../cubit/maintenacne_request_cubit.dart';
import 'maintenance_request_view.dart';

class MaintenanceRequestPage extends StatelessWidget {
  final Workshop workshop;
  const MaintenanceRequestPage({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    // Provide the MaintenanceRequestCubit to the widget tree.
    return BlocProvider(
      create: (_) => MaintenanceRequestCubit(MaintenanceRequestsRepository(),
          UserRepository(), StorageRepository()),
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "ارسال طلب صيانة",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Qcolors.secondary),
            )),
        body: MaintenanceRequestForm(
          workshop: workshop,
        ),
      ),
    );
  }
}
