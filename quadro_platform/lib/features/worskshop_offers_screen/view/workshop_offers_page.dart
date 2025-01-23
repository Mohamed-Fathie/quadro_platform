import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/workshop_repo.dart';
import 'package:quadro_platform/features/worskshop_offers_screen/cubit/workshop_offers_cubit.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/utils/constans/colors.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:sizer/sizer.dart';
import '../../workshop_main_screen/repository/repository_manager.dart';
import 'widgets/filter_list.dart';
import 'widgets/offers_list_view.dart';

class WorkshopOffersPage extends StatelessWidget {
  const WorkshopOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkshopOffersCubit(
          context.read<RepositoryManager>(), context.read<WorkshopRepository>())
        ..handleOfferFilterChange(0, RequestType.workshop_id),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "العروض",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Qcolors.primarycolor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(4.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 4.w,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                const SectionHeader(
                    requestType: RequestType.workshop_id,
                    text: "العروض الخاصة بي"),
                const FilterList(),
                BlocBuilder<WorkshopOffersCubit, WorkshopOffersState>(
                  builder: (context, state) {
                    return OffersListView(
                      state: state,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
