import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/user/view/workshop_search/bloc/workshop_search_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../features/user/repository/user_repository.dart';
import '../../../../features/workshop_authentication/repository/workshop_repo.dart';
import '../../../../features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import '../../../../features/workshop_main_screen/repository/offers_repository.dart';
import '../../../../features/workshop_main_screen/repository/repository_manager.dart';
import '../../../../features/workshop_profile/repository/reviews_repository.dart';
import 'workshop_search_view.dart';

class WorkshopSearchPage extends StatelessWidget {
  const WorkshopSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اختار الورشة",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Qcolors.secondary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: BlocProvider(
          create: (context) => WorkshopSearchBloc(
            RepositoryManager(
                reviewsRepository: ReviewsRepository(),
                maintenanceRequestsRepository: MaintenanceRequestsRepository(),
                offersRepository: OffersRepository(),
                userRepository: UserRepository(),
                workshopRepository: WorkshopRepository()),
          )..add(WorkshopFetched()),
          child: const WorkshopSearchView(),
        ),
      ),
    );
  }
}
