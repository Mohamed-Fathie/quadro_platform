import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/cubit/authbloc_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/workshop_authentication/veiws/id_screen.dart';

class WorkshopRegisterationPage extends StatelessWidget {
  const WorkshopRegisterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkshopAuthbloc(WorkshopRepository(), StorageRepository()),
      child: const IdCardView(),
    );
  }
}
