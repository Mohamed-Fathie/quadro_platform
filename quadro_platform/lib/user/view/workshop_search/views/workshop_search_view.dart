import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadro_platform/shared/enum/maitenance_request_status.dart';
import 'package:quadro_platform/shared/widgets/gradient_circular_progress.dart';
import 'package:quadro_platform/shared/widgets/section_header.dart';
import 'package:quadro_platform/user/view/workshop_search/bloc/workshop_search_bloc.dart';
import 'package:quadro_platform/user/view/workshop_search/views/widgets/workshop_list.dart';
import 'package:sizer/sizer.dart';

class WorkshopSearchView extends StatelessWidget {
  const WorkshopSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 3.h,
          ),
          const SectionHeader(
            text: "ورش بالقرب منك",
            requestType: RequestType.vehicle_owner_id,
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<WorkshopSearchBloc, WorkshopSearchState>(
            builder: (context, state) {
              if (state is WorkshopSearchFailure) {
                return SizedBox(
                  height: 50.h,
                  child: Text(
                    state.exception,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                );
              }

              if (state is WorkshopSearchSuccess) {
                return Flexible(
                  fit: FlexFit.loose,
                  child: WorkshopList(
                    workshops: state.workshop,
                  ),
                );
              }
              return SizedBox(
                  height: 50.h,
                  child: const Center(child: GradientCircularProgress()));
            },
          )
        ],
      ),
    );
  }
}
