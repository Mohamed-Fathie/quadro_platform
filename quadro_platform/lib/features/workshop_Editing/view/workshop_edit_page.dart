import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_Editing/cubit/workshop_edit_cubit.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/utils/constans/colors.dart';
import '../../workshop_main_screen/repository/repository_manager.dart';
import 'workshop_edit_view.dart';

class WorkshopEditPage extends StatelessWidget {
  // final WorkshopAuthbloc editCubit;

  const WorkshopEditPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkshopEditBloc(
          context.read<RepositoryManager>().workshopRepository,
          StorageRepository(),
          context.read<RepositoryManager>().userRepository)
        ..initializeData(),
      child: PopScope(
        canPop: false, // Prevents default pop behavior
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // When the user presses back, return a result
            Navigator.pop(
                context, true); // Replace 'true' with your actual result
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "تعديل بيانات الورشة",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: Qcolors.primarycolor),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0.1.h, 5.w, 0.5.h),
            child: const Directionality(
              textDirection: TextDirection.rtl,
              child: WorkshopEditView(),
            ),
          ),
        ),
      ),
    );
  }
}
